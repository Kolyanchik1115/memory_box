import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/profile_edit_page.dart';

import 'package:memory_box/pages/profile_pages/profile_page/widgets/avatar_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_page/widgets/logout_delete_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_page/widgets/phone_widget.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_subscribe.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile_pages/profile_page';

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    if (kDebugMode) {
      print(FirebaseAuth.instance.currentUser!.photoURL);
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: SvgPicture.asset(AppIcons.drawer)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: Customshape(),
            child: Container(
              color: AppColors.purple,
              width: double.infinity,
              height: height / 2.45,
            ),
          ),
          Column(
            children: [
              SizedBox(height: height / 12),
              const Center(
                child: TitleAppBarSubscribe(
                  title: 'Профиль',
                  'Твоя частичка',
                ),
              ),
              const SizedBox(height: 8),
              Avatar(
                color: AppColors.white,
                icon: SvgPicture.asset(AppIcons.camera),
              ),
              const SizedBox(height: 8),
              Text(
                (checkName())
                    ? 'Твое имя'
                    : FirebaseAuth.instance.currentUser!.displayName!,
                style: AppTextStyles.black24,
              ),
              SizedBox(height: height / 50),
              const PhoneWidget(),
              SizedBox(height: height / 80),
              TextButton(
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    ProfileEditPage.routeName,
                    (route) => false,
                  );
                },
                child: Text(
                  'Редактировать',
                  style: AppTextStyles.black14,
                ),
              ),
              const SizedBox(height: 45),
              TextButton(
                onPressed: () async {
                  
                },
                child: Text(
                  'Подписка',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                          color: AppColors.black, offset: const Offset(0, -3))
                    ],
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.black,
                    decorationThickness: 1,
                    fontSize: 14,
                    color: Colors.transparent,
                    fontFamily: AppFonts.fontFamily,
                    fontWeight: AppFonts.subtitle,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const LogoutDeleteWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
