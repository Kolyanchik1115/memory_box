import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class PhoneEditWidget extends StatefulWidget {
  final phoneController;
  final maskPhoneFormatter;

  const PhoneEditWidget({
    super.key,
    required this.maskPhoneFormatter,
    required this.phoneController,
  });

  @override
  State<PhoneEditWidget> createState() => _PhoneEditWidgetState();
}

class _PhoneEditWidgetState extends State<PhoneEditWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 319,
      height: 62,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: widget.phoneController,
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.black),
        inputFormatters: [widget.maskPhoneFormatter],
        cursorColor: AppColors.black,
        decoration: InputDecoration(
          hintText: FirebaseAuth.instance.currentUser!.phoneNumber,
          hintStyle: AppTextStyles.black18,
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
        keyboardType: TextInputType.phone,
      ),
    );
  }
}
