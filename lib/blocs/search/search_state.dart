part of 'search_bloc.dart';

class SearchState {
  final List<AudioModel> audioList;
  SearchState({
    this.audioList = const [],
  });

  SearchState copyWith({
    List<AudioModel>? audioList,
  }) {
    return SearchState(
      audioList: audioList ?? this.audioList,
    );
  }
}
