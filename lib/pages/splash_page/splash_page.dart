import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:memory_box/pages/registration_pages/hello_new_user.dart';
import 'package:memory_box/pages/registration_pages/splash_authorization_page.dart';
import 'package:memory_box/resources/app_fonts.dart';

import 'package:memory_box/utils/helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  Future<void> _navigateToPage() async {
    if (isAuth()) {
      await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        HelloNewUserPage.routeName,
        (_) => false,
      );
    } else {
      await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SplashAuthorizationPage.routeName,
        (_) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        log('SPLASH SCREEN');
        await _navigateToPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff678BD2),
            Color(0xff8C84E2),
          ], begin: Alignment.bottomRight),
        ),
        child: Center(
          child: Container(
            width: 312,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75),
              color: Colors.white,
            ),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: Text(
                  'MemoryBox',
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff8077E4),
                      fontWeight: AppFonts.regular,
                      letterSpacing: 1.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
