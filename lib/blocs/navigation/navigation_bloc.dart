import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/pages/home_page/home_page.dart';
import 'package:memory_box/utils/helpers.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateTab>((event, emit) {
      if (isAuth() && (event.tabIndex != 0 && event.tabIndex != 2)) {
        emit(state.copyWith(
          status: NavigationStatus.noUser,
        ));
      } else {
        emit(state.copyWith(
          status: NavigationStatus.tab,
          currentIndex: event.tabIndex,
          route: event.route,
        ));
      }
    });
    on<NavigateMenu>((event, emit) {
      emit(state.copyWith(
        status: NavigationStatus.menu,
        currentIndex: event.menuIndex,
        route: event.route,
      ));
    });
  }
}
