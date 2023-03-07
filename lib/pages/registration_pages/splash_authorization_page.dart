import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class SplashAuthorizationPage extends StatefulWidget {
  const SplashAuthorizationPage({super.key});
  static const routeName = '/registration_pages/splash_authorization_page';

  @override
  State<SplashAuthorizationPage> createState() =>
      _SplashAuthorizationPageState();
}

class _SplashAuthorizationPageState extends State<SplashAuthorizationPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        await Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(
          MainPage.routeName,
          (_) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: Customshape(),
                child: Container(
                  color: AppColors.purple,
                  width: double.infinity,
                  height: 380,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(55, 180, 20, 0),
                child: TitleAppBarRegistrationPage(
                  title: 'MemoryBox',
                  subtitle: 'Твой голос всегда рядом',
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 4),
              ),
            ], borderRadius: BorderRadius.circular(15), color: AppColors.white),
            width: 310,
            height: 80,
            padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
            child: Text(
              'Мы рады тебя видеть',
              textAlign: TextAlign.center,
              style: AppTextStyles.black24,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            AppIcons.heart,
            height: 60,
            width: 80,
          ),
          const SizedBox(
            height: 135,
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 4),
              ),
            ], borderRadius: BorderRadius.circular(15), color: AppColors.white),
            width: 300,
            height: 80,
            padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
            child: Text(
              'Взрослые иногда нуждаются в\n сказке даже больше, чем дети',
              textAlign: TextAlign.center,
              style: AppTextStyles.black14,
            ),
          ),
        ],
      ),
    );
  }
}
