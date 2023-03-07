import 'package:flutter/material.dart';

class VerificationProvider extends ChangeNotifier {
  String smsCode = '';
  String phoneNumber = '';
  String verificationId = '';
  void changeVerificationId(String id){
    verificationId = id;
    notifyListeners();
  }
  void changeNumber(String num){
    phoneNumber = num;
    notifyListeners();
  }
  void changeSmsCode(String sms){
    smsCode = sms;
    notifyListeners();
  }
}
