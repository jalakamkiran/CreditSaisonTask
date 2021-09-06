import 'package:flutter/cupertino.dart';
import 'dart:math';

class Calculation_Provider extends ChangeNotifier {
  double loan_emi = 0.0;
  double interest = 0.0;
  double total_amount = 0.0;

  double interest_percent = 0.0;
  double principle_percent = 0.0;

  double get loan_emi_price => loan_emi;

  double set_loan_emi_price(
      {double interest, double principle_amount, int tenure}) {
    double rate_of_interest_per_month = interest / 12 / 100;
    int tenure_in_months = (tenure * 12);
    var numerator = (pow(rate_of_interest_per_month + 1, tenure_in_months));
    var denomintor =
        (pow(rate_of_interest_per_month + 1, tenure_in_months)) - 1;
    loan_emi = (principle_amount * 100000) *
        rate_of_interest_per_month *
        ((numerator) / (denomintor));
    set_total_amount_price(loan_emi, tenure_in_months, principle_amount);
  }

  double get total_amount_payable => total_amount;

  double set_total_amount_price(
      double emi, int tenure_in_months, double principle_amount) {
    total_amount = emi * tenure_in_months;
    set_total_interest_amount(total_amount, principle_amount);
  }

  double get total_interest_amount => interest;

  double set_total_interest_amount(
      double total_amount_after_calc, double principle_amount) {
    interest = total_amount_after_calc - (principle_amount * 100000);
    set_percentage_for_interest(interest, principle_amount, total_amount);
  }

  double get percentage_for_interest => interest_percent;

  double set_percentage_for_interest(
      double interest_amount, double principle_amount, double total_amount) {
    interest_percent = (interest_amount / total_amount) * 100;
    set_percentage_for_principle(principle_amount, total_amount);
    print(interest_percent);
  }

  double get percentage_for_principle => interest_percent;

  double set_percentage_for_principle(
      double principle_amount, double total_amount) {
    principle_percent = (principle_amount * 100000 / total_amount) * 100;
    print(principle_percent);
    notifyListeners();
  }

  double reset_all() {
    loan_emi = 0.0;
    interest = 0.0;
    total_amount = 0.0;
    interest_percent = 0.0;
    principle_percent = 0.0;
    notifyListeners();
  }
}
