import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/pages/registration_pages/registration.dart';
import 'package:memory_box/pages/registration_pages/splash_registation_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/buttons/orange_recnagle_button.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:provider/provider.dart';

class SmsRegistrationPage extends StatefulWidget {
  const SmsRegistrationPage({super.key});

  static const routeName = '/registration_pages/sms_registration_page';

  @override
  State<SmsRegistrationPage> createState() => _SmsRegistrationPageState();
}

class _SmsRegistrationPageState extends State<SmsRegistrationPage> {
  final controller = TextEditingController();
  String verificationIdReceived = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool verificationConfirmed = false;

  Future<void> verifySms(String code, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: code,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential).then((value) {
      verificationConfirmed = true;
    });
  }

  Future<void> _checkSms() async {
    await verifySms(
        Provider.of<VerificationProvider>(context, listen: false)
            .verificationId,
        Provider.of<VerificationProvider>(context, listen: false).smsCode);
    if (verificationConfirmed) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const SplashRegistrationPage();
          },
        ),
      );
    } else {
      log('Wrong code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                padding: EdgeInsets.fromLTRB(40, 180, 20, 0),
                child: TitleAppBarRegistrationPage(
                  title: 'Регистрация',
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Введи код из смс, чтобы \nмы тебя запомнили',
                textAlign: TextAlign.center,
                style: AppTextStyles.black16,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 80,
              ),
              OrangeRectangleButton(
                text: 'Продолжить',
                onPressed: _checkSms,
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.white),
                width: 300,
                height: 100,
                padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
                child: Text(
                  'Регистрация привяжет твои сказки\n  к облаку, после чего они всегда\n    будут с тобой',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.black14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
