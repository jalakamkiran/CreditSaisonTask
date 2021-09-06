import 'package:flutter/cupertino.dart';

class LoanAmountProvider with ChangeNotifier {
  double loan_amount = 0.0;
  double get loan_price => loan_amount;

  void set(double value) {
    loan_amount = value;
    notifyListeners();
  }
}
