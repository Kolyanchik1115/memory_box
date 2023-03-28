import 'package:flutter/material.dart';
import 'package:memory_box/blocs/subscribe/subscribe_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class OrangeRectangleButton extends StatelessWidget {
  const OrangeRectangleButton(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  ElevatedButton build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    final height = MediaQuery.of(context).size.height * 0.06;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(
            width,
            height,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(51),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          AppColors.orange,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.white16,
      ),
    );
  }
}
