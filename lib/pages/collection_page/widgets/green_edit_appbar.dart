import 'package:flutter/material.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/button_back_widget.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class GreenEditAppbar extends StatelessWidget {
  const GreenEditAppbar({
    super.key,
    required this.onTap,
    required this.mainText,
    required this.rightText,
  });

  final VoidCallback onTap;
  final String mainText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonBackWidget(onTap: onTap),
              Text(
                mainText,
                style: AppTextStyles.white36,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  rightText,
                  style: AppTextStyles.white16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
