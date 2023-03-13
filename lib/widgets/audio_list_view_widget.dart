import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/pages/save_record_page/widgets/rounded_circle_thumb_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/utils/overlay_player.dart';
import 'package:memory_box/widgets/item_track_widget.dart';

class AudioListViewWidget extends StatefulWidget {
  const AudioListViewWidget({
    super.key,
    required this.icon,
    required this.iconPlay,
    required this.iconPause,
  });

  final SvgPicture icon;
  final SvgPicture iconPlay;
  final SvgPicture iconPause;

  @override
  State<AudioListViewWidget> createState() => _AudioListViewWidgetState();
}

class _AudioListViewWidgetState extends State<AudioListViewWidget> {
  int selectedIndex = -1;

  Future<void> refresh() async {
    context.read<AudioListBloc>().add(AudioListInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        String path;
        return Flexible(
          child: RefreshIndicator(
            color: AppColors.blue,
            onRefresh: refresh,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.audioList.length,
              itemBuilder: (context, index) {
                return UnconstrainedBox(
                  child: ItemTrackWidget(
                    path: state.audioList[index].path,
                    audioInSeconds:
                        state.audioList[index].recordDurationSeconds,
                    getId: state.audioList[index].id,
                    uuid: state.audioList[index].id,
                    nameAudio: state.audioList[index].titleOfAudio,
                    timeAudio: state.audioList[index].timeOfAudio,
                    index: index,
                    action: () {
                      context.read<PlayerBloc>().add(
                            PlayerInitOverlayEvent(state.audioList[index].path,
                                state.audioList[index].titleOfAudio),
                          );
                      if (OverlayPlayer.showDraggableFloat) {
                        OverlayPlayer.removePreviousOverlay();
                        _showOverlay();
                      } else {
                        _showOverlay();
                      }
                      setState(() {
                        selectedIndex = index;
                        OverlayPlayer.showDraggableFloat =
                            !OverlayPlayer.showDraggableFloat;
                      });
                    },
                    isActive: selectedIndex == index,
                    iconPause: widget.iconPause,
                    iconPlay: widget.iconPlay,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  _showOverlay() {
    OverlayPlayer.removePreviousOverlay();

    OverlayPlayer.overlayEntry = OverlayEntry(builder: (context) {
      return BlocBuilder<PlayerBloc, PlayersState>(
        builder: (context, state) {
          return DraggableFloatWidget(
            width: MediaQuery.of(context).size.width - 4,
            height: MediaQuery.of(context).size.height / 11,
            config: const DraggableFloatWidgetBaseConfig(
              initPositionYInTop: false,
              initPositionYMarginBorder: 50,
              borderTopContainTopBar: true,
              borderBottom: 100,
              borderRight: 2,
              borderLeft: 2,
            ),
            onTap: () => print('Drag onTap!'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [Color(0xff8c84e2), Color(0xff6c689f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 45,
                    onPressed: () async {
                      if (state.status == PlayerStatus.play) {
                        context.read<PlayerBloc>().add(PlayerPauseEvent());
                      } else {
                        context
                            .read<PlayerBloc>()
                            .add(PlayerStartOverlayEvent());
                      }
                      // await audioPlayer.play(source);
                    },
                    icon: SvgPicture.asset(state.status == PlayerStatus.play
                        ? AppIcons.whitePause
                        : AppIcons.whitePlay),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        state.fileName,
                        style: AppTextStyles.white14,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: SliderComponentShape.noOverlay,
                            overlayColor: Colors.transparent,
                            trackShape: const RectangularSliderTrackShape(),
                            thumbShape: CustomSliderThumbShape(),
                            trackHeight: 3.5,
                            thumbColor: AppColors.white,
                            inactiveTrackColor: AppColors.white,
                            activeTrackColor: AppColors.white,
                          ),
                          child: Slider(
                            min: 0,
                            max: state.duration.inSeconds.toDouble(),
                            value: state.position.inSeconds.toDouble(),
                            onChanged: (value) async {
                              context
                                  .read<PlayerBloc>()
                                  .add(PlayerPositionEvent(value));
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.positionView,
                              style: AppTextStyles.white10Opacity,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                            ),
                            Text(
                              state.durationView,
                              style: AppTextStyles.white10Opacity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      selectedIndex = -1;
                      OverlayPlayer.removePreviousOverlay();
                    },
                    icon: SvgPicture.asset(AppIcons.cross),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });

    /// Warning: context cannot be the context of MaterialApp
    Overlay.of(context).insert(OverlayPlayer.overlayEntry!);
  }
}
