import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/navigation/navigation_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/blocs/subscribe/subscribe_bloc.dart';
import 'package:memory_box/pages/audio_recording_page/audio_recording_page.dart';
import 'package:memory_box/pages/deleted_page/deleted_page.dart';
import 'package:memory_box/pages/deleted_page/select_to_delete_page.dart';
import 'package:memory_box/pages/home_page/home_page.dart';
import 'package:memory_box/pages/profile_pages/profile_page/profile_page.dart';
import 'package:memory_box/pages/recorder_pages/record_page.dart';
import 'package:memory_box/pages/search_page/search_page.dart';
import 'package:memory_box/pages/subscribe_page/subscribe_page.dart';

import 'package:memory_box/routes/app_routes.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:memory_box/widgets/navigation/bottom_navigation_bar.dart';
import 'package:memory_box/widgets/navigation/deleted_navbar.dart';
import 'package:memory_box/widgets/navigation/drawer_navigation.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  static const routeName = '/main_page';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static const List<String> _pages = [
    HomePage.routeName,
    ProfilePage.routeName,
    RecordPage.routeName,
    AudioRecordingsPage.routeName,
    DeletedPage.routeName,
    SelectToDeletePage.routeName,
    SearchPage.routeName,
    SubscribePage.routeName,
    // CollectionPage.routeName,
  ];

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
          create: (context) => AudioListBloc()
            ..add(
              AudioListInitialEvent(),
            ),
        ),

        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => SubscribeBloc(),
        ),
        // BlocProvider(
        //   create: (context) => CollectionBloc()..add(InitCollectionCardEvent()),
        // ),
        BlocProvider(
          create: (context) => PlayerBloc()..add(PlayerInitEvent()),
        ),
        // BlocProvider(
        //   create: (context) =>
        //       CreateCollectionBloc()..add(CollectionInitialEvent()),
        // ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (context, state) async {
          if (state.status == NavigationStatus.menu) {
            _onSelectMenu(state.route);
          }

          if (state.status == NavigationStatus.tab) {
            _onSelectTab(state.route);
          }
          if (state.status == NavigationStatus.noUser) {
            await showDialogAcc(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            key: _key,
            bottomNavigationBar: (state.currentIndex != 8)
                ? CustomBNBar(
                    onSelect: (index) {
                      if (state.currentIndex != index) {
                        context
                            .read<AudioListBloc>()
                            .add(AudioListInitialEvent());
                        context.read<NavigationBloc>().add(
                              NavigateTab(
                                tabIndex: index,
                                route: _pages[index],
                              ),
                            );
                      }
                    },
                    currentTab: state.currentIndex,
                  )
                : DeletedBottomBar(
                    onDelete: () {
                      context
                          .read<AudioListBloc>()
                          .add(AudioListRemoveSelectedEvent());
                      context.read<NavigationBloc>().add(
                            NavigateMenu(
                              menuIndex: 9,
                              route: _pages[9],
                            ),
                          );
                    },
                    onRestore: () {
                      context
                          .read<AudioListBloc>()
                          .add(AudioListRestoreSelectedEvent());
                      context.read<NavigationBloc>().add(
                            NavigateMenu(
                              menuIndex: 9,
                              route: _pages[9],
                            ),
                          );
                    },
                  ),
            drawer: DrawerNavigation(
              onSelect: (int index) {
                if (state.currentIndex != index) {
                  context.read<NavigationBloc>().add(
                        NavigateMenu(
                          route: _pages[index],
                          menuIndex: index,
                        ),
                      );
                }
              },
              currentTab: state.currentIndex,
            ),
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
