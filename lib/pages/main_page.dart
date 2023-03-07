import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocs/navigation/navigation_bloc.dart';
import 'package:memory_box/pages/home_page/home_page.dart';

import 'package:memory_box/routes/app_routes.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  static const routeName = '/main_page';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  void _onSelectTab(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (route) => false,
      );
    }
  }

  void _onSelectMenu(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _key.currentState?.openDrawer();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (context, state) async {
          if (state.status == NavigationStatus.menu) {
            _onSelectMenu(state.route);
          }
          if (state.status == NavigationStatus.tab) {
            _onSelectTab(state.route);
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            key: _key,
            body: Navigator(
              key: _navigatorKey,
              initialRoute: HomePage.routeName,
              onGenerateRoute: AppRouter.generateRoute,
            ),
          );
        },
      ),
    );
  }
}
