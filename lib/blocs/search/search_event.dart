part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchInitEvent extends SearchEvent {}

class SearchFindEvent extends SearchEvent {
  final String enteredText;

  SearchFindEvent({
    required this.enteredText,
  });
}
