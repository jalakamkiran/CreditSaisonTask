import 'package:flutter/cupertino.dart';

class LoanInterestRateProvider with ChangeNotifier {
  double intrest = 5.0;
  double get interest_rate => intrest;

  void set(double value) {
    intrest = value;
    notifyListeners();
  }
}
