import 'package:flutter/material.dart';
import 'package:memory_box/pages/registration_pages/phone_registration_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/buttons/orange_recnagle_button.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class HelloNewUserPage extends StatelessWidget {
  const HelloNewUserPage({super.key});

  static const routeName = '/registration_pages/hello_new_user_page';

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
          Column(
            children: [
              Text(
                'Привет!',
                style: AppTextStyles.black24,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Мы рады видеть тебя здесь. \n Это приложение поможет записывать \n сказки и держать их в удобном месте не \nзаполняя память на телефоне',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 48,
              ),
              OrangeRectangleButton(
                text: 'Продолжить',
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    PhoneRegistrationPage.routeName,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
