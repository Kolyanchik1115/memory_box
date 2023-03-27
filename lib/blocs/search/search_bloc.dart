import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/utils/helpers.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<SearchInitEvent>((event, emit) async {
      final audioList = await getListAudioHelper();
      final listNotDeletedAudio =
          audioList.where((element) => element.removedStatus == false).toList();
      emit(state.copyWith(audioList: listNotDeletedAudio));
    });
    on<SearchFindEvent>((event, emit) async {
      final audioList = await getListAudioHelper();
      final counterAudio =
          audioList.where((element) => element.removedStatus == false).toList();

      final request = counterAudio.where((audio) {
        final titleOfAudio = audio.titleOfAudio.toLowerCase();
        final input = event.enteredText.toLowerCase();
        return titleOfAudio.contains(input);
      }).toList();
      emit(state.copyWith(
        audioList: event.enteredText != '' ? request : counterAudio.toList(),
      ));
    });
  }
}
