import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:memory_box/pages/registration_pages/registration.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:provider/provider.dart';

class EnterPhoneWidget extends StatefulWidget {
  final phoneController;
  final maskPhoneFormatter;
  const EnterPhoneWidget({
    super.key,
    required this.phoneController,
    required this.maskPhoneFormatter,
  });

  @override
  State<EnterPhoneWidget> createState() => EnterPhoneWidgetState();
}

class EnterPhoneWidgetState extends State<EnterPhoneWidget> {
  final phoneController = TextEditingController();
  final maskPhoneFormatter = MaskTextInputFormatter(
      mask: '+##(###)###-##-##', filter: {'#': RegExp('[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.06,
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
        onChanged: (text) {
          Provider.of<VerificationProvider>(context, listen: false)
              .changeNumber(text);
        },
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.black),
        inputFormatters: [widget.maskPhoneFormatter],
        cursorColor: AppColors.white,
        decoration: InputDecoration(
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
