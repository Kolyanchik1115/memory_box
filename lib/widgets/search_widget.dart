import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  final TextEditingController controller;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      width: width,
      height: 60,
      margin: const EdgeInsets.all(16),
      child: TextField(
        style: AppTextStyles.black20,
        cursorColor: AppColors.grey,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 30),
          hintText: 'Поиск',
          hintStyle: AppTextStyles.grey20,
          filled: true,
          fillColor: AppColors.white,
          suffixIcon: Align(
            widthFactor: 2.5,
            child: SvgPicture.asset(AppIcons.search),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
