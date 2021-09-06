import 'package:flutter/cupertino.dart';

class LoanTenureProvider with ChangeNotifier {
  double loan_tenure = 0;
  double get tenure => loan_tenure;

  void set(double value) {
    loan_tenure = value;
    notifyListeners();
  }
}
