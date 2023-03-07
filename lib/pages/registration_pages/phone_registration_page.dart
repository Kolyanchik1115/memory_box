import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:memory_box/blocs/auth/auth_bloc.dart';

import 'package:memory_box/pages/main_page.dart';
import 'package:memory_box/pages/registration_pages/splash_registation_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/buttons/orange_recnagle_button.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:memory_box/widgets/enter_phone_widget.dart';
import 'package:memory_box/widgets/enter_sms_widget.dart';

class PhoneRegistrationPage extends StatefulWidget {
  const PhoneRegistrationPage({super.key});

  static const routeName = '/registration_pages/phone_registration_page';

  @override
  State<PhoneRegistrationPage> createState() => _PhoneRegistrationPageState();
}

class _PhoneRegistrationPageState extends State<PhoneRegistrationPage> {
  final phoneController = TextEditingController();
  final smsController = TextEditingController();
  final maskPhoneFormatter = MaskTextInputFormatter(
      mask: '+##(###)###-##-##', filter: {'#': RegExp('[0-9]')});
  final maskSmsFormatter =
      MaskTextInputFormatter(mask: '######', filter: {'#': RegExp('[0-9]')});
  String verificationIdReceived = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.status == AuthStatus.verified) {
            await Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(
              SplashRegistrationPage.routeName,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                ClipPath(
                  clipper: Customshape(),
                  child: Container(
                    color: AppColors.purple,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const Spacer(flex: 4),
                      const Expanded(
                        flex: 5,
                        child: TitleAppBarRegistrationPage(
                          title: 'Регистрация',
                        ),
                      ),
                      const Spacer(flex: 2),
                      if (state.status == AuthStatus.phone)
                        Expanded(
                          child: Text(
                            'Введи номер телефона',
                            style: AppTextStyles.black16,
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            'Введи код из смс, чтобы \nмы тебя запомнили',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.black16,
                          ),
                        ),
                      if (state.status == AuthStatus.phone)
                        EnterPhoneWidget(
                          phoneController: phoneController,
                          maskPhoneFormatter: maskPhoneFormatter,
                        )
                      else
                        EnterSmsWidget(
                          maskSmsFormatter: maskSmsFormatter,
                          smsController: smsController,
                        ),
                      const Spacer(
                        flex: 2,
                      ),
                      OrangeRectangleButton(
                        text: 'Продолжить',
                        onPressed: () {
                          if (state.status == AuthStatus.phone) {
                            context.read<AuthBloc>().add(
                                  AuthPhoneEvent(
                                    phoneNumber:
                                        maskPhoneFormatter.getUnmaskedText(),
                                  ),
                                );
                          } else {
                            context.read<AuthBloc>().add(
                                  AuthSmsEvent(
                                    smsCode: maskSmsFormatter.getUnmaskedText(),
                                  ),
                                );
                          }
                        },
                      ),
                      if (state.status == AuthStatus.phone)
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              await Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                MainPage.routeName,
                                (_) => false,
                              );
                            },
                            child: Text(
                              'Позже',
                              style: AppTextStyles.black24,
                            ),
                          ),
                        )
                      else
                        const Spacer(flex: 2),
                      FittedBox(
                        // flex: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
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
                          padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                          child: Text(
                            'Регистрация привяжет твои сказки\n  к облаку, после чего они всегда\n    будут с тобой',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.black14,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
