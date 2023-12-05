import 'package:flutter/material.dart';

class ValueModel extends ChangeNotifier {
  double dollarValue = 0;

  void updateDollarValue(value) {
    if (value != dollarValue) {
      dollarValue = value;
      notifyListeners();
    }
  }
  void notify() {
    notifyListeners();
  }
}