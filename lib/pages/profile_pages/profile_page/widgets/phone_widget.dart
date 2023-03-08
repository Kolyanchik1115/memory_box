import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneWidget extends StatelessWidget {
  const PhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 319,
      height: 62,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 4,
          blurRadius: 10,
          offset: const Offset(0, 4), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.circular(41), color: AppColors.white),
      child: Center(
          child: Text(
        FirebaseAuth.instance.currentUser!.phoneNumber!,
        style: AppTextStyles.black20,
      )),
    );
  }
}
