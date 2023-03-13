import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:share_plus/share_plus.dart';

import '../../../resources/app_icons.dart';

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 35),
      color: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      icon: SvgPicture.asset(AppIcons.tripleMenu),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Добавить в подборку',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Редактировать название',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () async {
              await Share.shareXFiles([
                XFile(
                    '/data/user/0/com.example.memory_box/cache/Аудиозапись.mp4')
              ], text: 'Моя новая  сказка!');
            },
            child: Text(
              'Поделиться',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Скачать',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Удалить',
              style: AppTextStyles.black14,
            ),
          ),
        ),
      ],
    );
  }
}
