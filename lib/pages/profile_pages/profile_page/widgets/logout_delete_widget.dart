import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_box/pages/splash_page/splash_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/utils/helpers.dart';

class LogoutDeleteWidget extends StatefulWidget {
  const LogoutDeleteWidget({super.key});

  @override
  State<LogoutDeleteWidget> createState() => _LogoutDeleteWidgetState();
}

class _LogoutDeleteWidgetState extends State<LogoutDeleteWidget> {
  Future<void> showDialogDeleteAcc() async {
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
                    'Точно удалить аккаунт?',
                    style: AppTextStyles.black20,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Все аудиофайлы исчезнут и\nвосстановить аккаунт будет \nневозможно',
                    style: AppTextStyles.grey14,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          isLogOut();
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                          // isLogOutTwo();
                          Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil(
                            SplashScreen.routeName,
                            (_) => false,
                          );
                        },
                        child: Container(
                          width: 124,
                          height: 41,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(51),
                            ),
                            color: AppColors.red,
                          ),
                          child: Center(
                            child: Text(
                              'Удалить',
                              style: AppTextStyles.white16,
                            ),
                          ),
                        ),
                      ),
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
                            border:
                                Border.all(color: AppColors.purple, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              'Нет',
                              style: AppTextStyles.purple16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Text(
            'Выйти из приложения',
            style: AppTextStyles.black14,
          ),
        ),
        TextButton(
          onPressed: showDialogDeleteAcc,
          child: Text(
            'Удалить аккаунт',
            style: AppTextStyles.red14,
          ),
        ),
      ],
    );
  }
}
