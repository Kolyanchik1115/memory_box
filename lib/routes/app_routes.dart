import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/pages/home_page/home_page.dart';
import 'package:memory_box/pages/main_page.dart';
import 'package:memory_box/pages/registration_pages/hello_new_user.dart';
import 'package:memory_box/pages/registration_pages/phone_registration_page.dart';
import 'package:memory_box/pages/registration_pages/sms_registration_page.dart';
import 'package:memory_box/pages/registration_pages/splash_authorization_page.dart';
import 'package:memory_box/pages/registration_pages/splash_registation_page.dart';
import 'package:memory_box/pages/splash_page/splash_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    if (kDebugMode) {
      print(settings.name);
    }
    switch (settings.name) {
      case HelloNewUserPage.routeName:
        builder = (_) => const HelloNewUserPage();
        break;

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

      case MainPage.routeName:
        builder = (_) => MainPage();
        break;

      case PhoneRegistrationPage.routeName:
        builder = (_) => const PhoneRegistrationPage();
        break;
      case SmsRegistrationPage.routeName:
        builder = (_) => const SmsRegistrationPage();
        break;
      case SplashAuthorizationPage.routeName:
        builder = (_) => const SplashAuthorizationPage();
        break;
      case SplashRegistrationPage.routeName:
        builder = (_) => const SplashRegistrationPage();
        break;

      case SplashScreen.routeName:
        builder = (_) => const SplashScreen();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
