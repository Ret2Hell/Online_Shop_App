import 'package:flutter/material.dart';

class AccountInfoProvider extends ChangeNotifier {
  final Map<String, dynamic> accountInfo = {};

  void updateAccountInfo(Map<String, dynamic> newAccountInfo) {
    accountInfo.addAll(newAccountInfo);
    notifyListeners();
  }

  void updateAccountInfoField(String key, dynamic value) {
    accountInfo[key] = value;
    notifyListeners();
  }
}
