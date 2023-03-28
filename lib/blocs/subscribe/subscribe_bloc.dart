import 'package:flutter_bloc/flutter_bloc.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc() : super(SubscribeState()) {
    on<ChangeSubscribeEvent>((event, emit) {
      emit(state.copyWith(changeYear: !event.changeSub));
    });
  }
}
