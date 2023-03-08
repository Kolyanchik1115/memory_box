import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: SvgPicture.asset(AppIcons.goBack),
        ),
      ),
    );
  }
}
