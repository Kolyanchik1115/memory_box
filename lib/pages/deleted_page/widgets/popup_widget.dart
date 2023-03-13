import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';


import 'package:memory_box/resources/app_icons.dart';

class PopupWidget extends StatelessWidget {
  const PopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 35),
      color: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      icon: SvgPicture.asset(AppIcons.tripleMenu),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Выбрать несколько',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Удалить все',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Восстановить все',
              style: AppTextStyles.black14,
            ),
          ),
        ),
      ],
    );
  }
}
