part of 'subscribe_bloc.dart';

class SubscribeState {
  final bool changeYear;
  SubscribeState({
    this.changeYear = true,
  });

  SubscribeState copyWith({
    bool? changeYear,
  }) {
    return SubscribeState(
      changeYear: changeYear ?? this.changeYear,
    );
  }
}
