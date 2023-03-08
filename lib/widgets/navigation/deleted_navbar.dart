import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

import '../../resources/app_colors.dart';

class DeletedBottomBar extends StatelessWidget {
  const DeletedBottomBar({
    super.key,
    required this.onDelete,
    required this.onRestore,
  });

  final VoidCallback onDelete;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.zero,
      height: height / 9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 50,
            blurRadius: 100,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ItemButton(
            title: 'Восстановить',
            icon: SvgPicture.asset(AppIcons.swap),
            onPressed: onRestore,
          ),
          ItemButton(
            title: 'Удалить',
            icon: SvgPicture.asset(AppIcons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  final String title;
  final SvgPicture icon;
  final VoidCallback onPressed;

  const ItemButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
        Text(
          title,
          style: AppTextStyles.black10,
        ),
      ],
    );
  }
}
