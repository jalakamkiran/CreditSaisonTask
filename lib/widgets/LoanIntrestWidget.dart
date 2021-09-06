import 'package:credit_saison_project/providers/loan_amount_provider.dart';
import 'package:credit_saison_project/providers/loan_intrest_rate_provider.dart';
import 'package:credit_saison_project/providers/loan_tenure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanIntrestWidget extends StatelessWidget {
  TextEditingController intrest_controller;
  FocusScopeNode scopeNode;
  LoanIntrestWidget({this.intrest_controller, this.scopeNode});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanInterestRateProvider>(
        builder: (context, tenureprovider, child) {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Loan Intrest",
                  suffix: Text(
                    "%",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  tenureprovider.set(double.parse(value));
                  intrest_controller.text =
                      tenureprovider.interest_rate.toString();
                },
                controller: intrest_controller,
              ),
              Slider(
                  value: tenureprovider.interest_rate,
                  max: 20,
                  min: 5,
                  label: tenureprovider.interest_rate.toString() + "%",
                  divisions: 8,
                  onChanged: (value) {
                    tenureprovider.set(value);
                    intrest_controller.text =
                        tenureprovider.interest_rate.toString();
                  }),
            ],
          ),
        ),
      );
    });
  }
}
