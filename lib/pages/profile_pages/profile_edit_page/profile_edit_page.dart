import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:memory_box/blocs/auth/auth_bloc.dart';
import 'package:memory_box/blocs/navigation/navigation_bloc.dart';

import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/button_back_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/nickname_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/phone_edit_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_page/profile_page.dart';
import 'package:memory_box/pages/splash_page/splash_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_subscribe.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:memory_box/widgets/enter_sms_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../resources/app_icons.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({super.key});

  final phoneController = TextEditingController();
  final smsController = TextEditingController();
  final maskPhoneFormatter = MaskTextInputFormatter(
      mask: '+##(###)###-##-##', filter: {'#': RegExp('[0-9]')});
  final maskSmsFormatter =
      MaskTextInputFormatter(mask: '######', filter: {'#': RegExp('[0-9]')});

  static const routeName = '/profile_pages/profile_edit_page';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            extendBodyBehindAppBar: true,
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
                    SizedBox(height: height / 20),
                    Row(
                      children: [
                        ButtonBackWidget(
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, ProfilePage.routeName);
                          },
                        ),
                        SizedBox(width: width / 10),
                        const TitleAppBarSubscribe(
                          title: 'Профиль',
                          'Твоя частичка',
                        ),
                      ],
                    ),
                    SizedBox(height: height / 20),
                    SizedBox(
                      height: height / 3.9,
                      width: width / 1.8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        width: width / 1.8,
                        height: height / 3.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: (state.pathToAvatar.isNotEmpty)
                              ? Image.network(
                                  state.pathToAvatar,
                                  fit: BoxFit.fitWidth,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(UserAvatarEvent());
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      height: height / 3.9,
                                      width: width / 1.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.grey.withOpacity(0.8),
                                        image: DecorationImage(
                                          image: NetworkImage((FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .photoURL !=
                                                  null)
                                              ? FirebaseAuth.instance
                                                  .currentUser!.photoURL!
                                              : 'https://vdostavka.ru/wp-content/uploads/2019/05/no-avatar'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          AppIcons.camera,
                                          height: 80,
                                          width: 80,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const NicknameWidget(),
                    SizedBox(height: height / 10),
                    if (state.status == AuthStatus.phone)
                      PhoneEditWidget(
                        maskPhoneFormatter: maskPhoneFormatter,
                        phoneController: phoneController,
                      )
                    else
                      EnterSmsWidget(
                          maskSmsFormatter: maskSmsFormatter,
                          smsController: smsController),
                    const SizedBox(height: 20),
                    if (state.status == AuthStatus.phone)
                      TextButton(
                        onPressed: () async {
                          if (maskPhoneFormatter.getUnmaskedText().isEmpty) {
                            context.read<AuthBloc>().add(UserInfoSaveEvent());
                            Future.delayed(
                              const Duration(milliseconds: 1500),
                              () async {
                                context.read<NavigationBloc>().add(
                                      NavigateMenu(
                                        menuIndex: 4,
                                        route: ProfilePage.routeName,
                                      ),
                                    );
                              },
                            );
                          } else {
                            context.read<AuthBloc>().add(
                                  AuthPhoneEvent(
                                    phoneNumber:
                                        maskPhoneFormatter.getUnmaskedText(),
                                  ),
                                );
                          }
                        },
                        child: Text(
                          'Сохранить',
                          style: AppTextStyles.black14,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthSmsEvent(
                                  smsCode: maskSmsFormatter.getUnmaskedText(),
                                ),
                              );
                          Future.delayed(
                            const Duration(milliseconds: 1500),
                            () async {
                              context.read<NavigationBloc>().add(
                                    NavigateMenu(
                                      menuIndex: 4,
                                      route: ProfilePage.routeName,
                                    ),
                                  );
                            },
                          );
                        },
                        child: Text(
                          'Подтвердить код из смс',
                          style: AppTextStyles.black14,
                        ),
                      )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> showDialogDeleteAcc(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            content: SizedBox(
              width: 320,
              height: 248,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Ты не зарегистрирован',
                    style: AppTextStyles.black20,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                    style: AppTextStyles.black14,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Container(
                        width: 84,
                        height: 41,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(51),
                          ),
                          border:
                              Border.all(color: AppColors.purple, width: 1.5),
                        ),
                        child: Row(children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 84,
                              height: 41,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(51),
                                ),
                                border: Border.all(
                                    color: AppColors.purple, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  'OK',
                                  style: AppTextStyles.purple16,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  SplashScreen.routeName, (route) => false);
                            },
                            child: Container(
                              width: 84,
                              height: 41,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(51),
                                ),
                                border: Border.all(
                                    color: AppColors.purple, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  'Зарегистрироваться',
                                  style: AppTextStyles.purple16,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
