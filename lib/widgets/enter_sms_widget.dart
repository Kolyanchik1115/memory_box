import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:memory_box/pages/registration_pages/registration.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:provider/provider.dart';

class EnterSmsWidget extends StatefulWidget {
  final maskSmsFormatter;
  final smsController;

  const EnterSmsWidget({
    super.key,
    required this.maskSmsFormatter,
    required this.smsController,
  });

  @override
  State<EnterSmsWidget> createState() => _EnterSmsWidgetState();
}

class _EnterSmsWidgetState extends State<EnterSmsWidget> {
  final smsController = TextEditingController();
  final maskSmsFormatter =
      MaskTextInputFormatter(mask: '######', filter: {'#': RegExp('[0-9]')});

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
        controller: widget.smsController,
        onChanged: (text) {
          Provider.of<VerificationProvider>(context, listen: false)
              .changeSmsCode(text);
        },
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.black),
        inputFormatters: [widget.maskSmsFormatter],
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
        keyboardType: TextInputType.number,
      ),
    );
  }
}
