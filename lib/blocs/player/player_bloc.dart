import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayersState> {
  PlayerBloc() : super(const PlayersState()) {
    initPlayer();
    on<PlayerDownloadEvent>((event, emit) async {
      Uint8List? audioFile;
      final path = File('/data/user/0/com.example.memory_box/cache/audio.mp4');
      audioFile = await path.readAsBytes();
      const format = '.mp3';
      const mimeType = MimeType.MP3;
      await FileSaver.instance
          .saveAs('Аудиозапись', audioFile, format, mimeType);
    });

    on<PlayerGetModelEvent>((event, emit) async {
      playList = event.listAudioModels;
      add(
        PlayerInitOverlayEvent(
          playList!.first.path,
          playList!.first.titleOfAudio,
        ),
      );
      emit(state.copyWith(
        id: playList!.first.id,
      ));
    });

    on<PlayerInitOverlayEvent>((event, emit) {
      emit(state.copyWith(
        fileName: event.titleOfAudio,
        path: event.path,
      ));
      add(PlayerStartOverlayEvent());
    });

    on<PlayerStartOverlayEvent>((event, emit) async {
      initPlayer();
      isPlaying = false;

      print(state.path);
      await playFirebase(state.path);
      player.onDurationChanged.listen(
        (seekDuration) {
          duration = seekDuration;
        },
      );
      player.setReleaseMode(ReleaseMode.stop);
      player.onPlayerComplete.listen(
        (event) {
          print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
          if (playList!.length > 1) {
            add(
              PlayerGetModelEvent(
                listAudioModels: playList!.sublist(1),
              ),
            );
          }
        },
      );
      player.onPositionChanged.listen(
        (seekPosition) {
          position = seekPosition;
          add(
            PlayerTickEvent(
              timerFormat.format(duration),
              timerFormat.format(position),
              duration,
              position,
            ),
          );
        },
      );
      emit(state.copyWith(
          // isPlaying: isPlaying,
          ));
    });

    on<GetModelFromFirebase>((event, emit) async {
      if (isAuth()) {
      } else {
        String uuid = event.uuid;
        Map<String, dynamic> model = await getInfo(uuid);
        emit(state.copyWith(
          fileName: model['titleOfAudio'],
          durationView: model['durationOfAudio'],
        ));
      }
    });
    on<PlayerRenameEvent>((event, emit) async {
      String uuid = event.uuid;
      String titleOfAudio = event.titleOfAudio;
      final renameAudio = await _renameAudio(uuid, titleOfAudio);
      emit(state.copyWith(
        fileName: renameAudio.toString(),
      ));
    });

    on<PlayerInitEvent>(
      (event, emit) async {
        // final durationAudio = await getDurationValue();
        await setAudio();
        // emit(state.copyWith(
        //   // durationView: durationAudio,
        //
        // ));
      },
    );
    on<PlayerInitialUuidEvent>((event, emit) {
      emit(state.copyWith(
        uuid: event.uuid,
      ));
    });
    on<PlayerStartEvent>(
      (event, emit) async {
        initPlayer();
        if (isAuth()) {
          playLocal();
        } else {
          String uuid = event.uuid;
          final AudioModel audioModel = await _getPathAudio(uuid);
          playFirebase(audioModel.path);
        }

        player.onDurationChanged.listen(
          (seekDuration) {
            duration = seekDuration;
          },
        );
        player.onPositionChanged.listen(
          (seekPosition) {
            position = seekPosition;

            if (position.inSeconds != duration.inSeconds) {
              add(
                PlayerTickEvent(
                  timerFormat.format(duration),
                  timerFormat.format(position),
                  duration,
                  position,
                ),
              );
            } else {
              print('Stoooop');
            }
          },
        );
      },
    );
    on<PlayerPauseResumeEvent>((event, emit) async {
      if (isPlaying) {
        isPlaying = false;
        await player.pause();
      } else {
        isPlaying = true;
        await player.resume();
      }
      emit(state.copyWith(duration: duration, isPause: isPlaying));
    });
    on<PlayerPauseEvent>(
      (event, emit) async {
        pause();
        emit(
          state.copyWith(
            durationView: timerFormat.format(duration),
            positionView: timerFormat.format(position),
            duration: duration,
            position: position,
            status: PlayerStatus.stop,
            isPause: true,
          ),
        );
      },
    );
    on<PlayerStopEvent>(
      (event, emit) async {
        position = const Duration(seconds: 0);
        seek = false;
        fastForward();
        close();
        emit(
          state.copyWith(
            durationView: timerFormat.format(duration),
            positionView: timerFormat.format(position),
            duration: duration,
            position: position,
            status: PlayerStatus.stop,
          ),
        );
      },
    );

    on<PlayerBackEvent>(
      (event, emit) async {
        position -= const Duration(seconds: 15);

        fastForward();

        emit(
          state.copyWith(
            durationView: timerFormat.format(duration),
            positionView: timerFormat.format(position),
            duration: duration,
            position: position,
            status: seek ? PlayerStatus.play : PlayerStatus.stop,
          ),
        );
      },
    );
    on<PlayerForwardEvent>(
      (event, emit) async {
        position += const Duration(seconds: 15);

        fastForward();

        emit(
          state.copyWith(
            durationView: timerFormat.format(duration),
            positionView: timerFormat.format(position),
            duration: duration,
            position: position,
            status: seek ? PlayerStatus.play : PlayerStatus.stop,
          ),
        );
      },
    );

    on<PlayerPositionEvent>(
      (event, emit) async {
        position = Duration(seconds: event.value.toInt());
        fastForward();
        emit(
          state.copyWith(
            durationView: timerFormat.format(duration),
            positionView: timerFormat.format(position),
            duration: duration,
            position: position,
            status: seek ? PlayerStatus.play : PlayerStatus.stop,
          ),
        );
      },
    );
    on<PlayerTickEvent>(
      (event, emit) {
        emit(
          state.copyWith(
            durationView: event.durationView,
            positionView: event.positionView,
            duration: event.duration,
            position: event.position,
            isPause: false,
            status: PlayerStatus.play,
          ),
        );
      },
    );
  }

  List<AudioModel>? playList;
  final TimerFormat timerFormat = TimerFormat();
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  bool seek = true;
  List<AudioModel> listAudioModels = [];

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future<String> _renameAudio(String uuid, String renameAudio) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(uuid).update({'titleOfAudio': renameAudio});
    return renameAudio;
  }

  Future _getListAudioModels(id) async {
    final sort = await FirebaseFirestore.instance
        .collection('users')
        .doc(AudioId.audioId)
        .collection('audioList')
        .where('id', isEqualTo: id)
        .get()
        .then((value) => value.docs);
    listAudioModels = sort.map((e) => AudioModel.fromJson(e.data())).toList();
    return listAudioModels;
  }

  void initPlayer() {
    player.onPlayerStateChanged.listen(
      (state) {
        isPlaying = state == PlayerState.playing;
      },
    );
  }

  @override
  Future<void> close() {
    player.stop();
    player.dispose();
    return super.close();
  }

  Future<void> playFirebase(String pathToAudio) async {
    await player.play(UrlSource(pathToAudio));
    seek = true;
  }

  Future<void> playLocal() async {
    await player
        .play(UrlSource('/data/user/0/com.example.memory_box/cache/audio.mp4'));
    print(player.getDuration().toString());
    seek = true;
  }

  Future<void> pause() async {
    await player.pause();
    seek = false;
  }

  Future<void> fastForward() async {
    await player.seek(position);
    if (seek) {
      await player.resume();
    }
  }

  Future<String> getDurationValue() async {
    final pathToAudio = await _getLastAudio();
    await player.setSourceDeviceFile(pathToAudio);
    final valueDuration = await player.getDuration();
    final valueString = timerFormat.format(valueDuration!);
    return valueString;
  }

  Future setAudio() async {
    await player.setReleaseMode(ReleaseMode.loop);
  }

  Future<String> _getLastAudio() async {
    final sort = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .orderBy('titleOfAudio', descending: false);
    final QuerySnapshot querySnapshot = await sort.get();
    final listAudio = querySnapshot.docs
        .map((e) => AudioModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    print(listAudio.last.titleOfAudio);
    final pathToAudio = listAudio.last.path;
    print(listAudio.last.path);
    return pathToAudio;
  }

  Future<AudioModel> _getPathAudio(String uuid) async {
    final model = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .doc(uuid)
        .get();
    return AudioModel.fromJson(model.data() as Map<String, dynamic>);
  }

  Future getInfo(String uuid) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    var docSnapshot = await collection.doc(uuid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      final audioName = data['titleOfAudio'];
      return data;
    }
  }
}
