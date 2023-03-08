import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class TitleAppBarSubscribe extends StatelessWidget {
  final String title;
  final String? subtitle;

  const TitleAppBarSubscribe(
    this.subtitle, {
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.white36,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle ?? '',
          style: AppTextStyles.white16,
        )
      ],
    );
  }
}
