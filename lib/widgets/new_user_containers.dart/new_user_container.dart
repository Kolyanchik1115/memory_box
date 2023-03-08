import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class GreenRectangleWidget extends StatelessWidget {
  const GreenRectangleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      height: MediaQuery.of(context).size.height * 0.27,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 8,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        color: AppColors.green.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Здесь будет твой набор сказок',
            style: AppTextStyles.white20,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Добавить',
              style: TextStyle(
                shadows: [
                  Shadow(color: AppColors.white, offset: const Offset(0, -5))
                ],
                decoration: TextDecoration.underline,
                fontFamily: AppFonts.fontFamily,
                decorationColor: AppColors.white,
                decorationThickness: 1,
                fontSize: 14,
                color: Colors.transparent,
                fontWeight: AppFonts.subtitle,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class OrangeRectangleWidget extends StatelessWidget {
  const OrangeRectangleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'Тут',
          style: AppTextStyles.white20,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class BlueRectangleWidget extends StatelessWidget {
  const BlueRectangleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.44,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 8,
              blurRadius: 10,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
          color: AppColors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'И тут',
            style: AppTextStyles.white20,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
