import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class SplashRegistrationPage extends StatefulWidget {
  const SplashRegistrationPage({super.key});
  static const routeName = '/registration_pages/splash_registation_page';

  @override
  State<SplashRegistrationPage> createState() => _SplashRegistrationPageState();
}

class _SplashRegistrationPageState extends State<SplashRegistrationPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
          () async {
            await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
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
                padding: EdgeInsets.fromLTRB(75, 180, 20, 0),
                child: TitleAppBarRegistrationPage(
                  title: 'Ты супер!',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 78,
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
        ],
      ),
    );
  }
}
