import 'package:credit_saison_project/providers/loan_amount_provider.dart';
import 'package:credit_saison_project/providers/loan_tenure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanTenureWidget extends StatelessWidget {
  TextEditingController loan_tenure_controller;
  LoanTenureWidget({this.loan_tenure_controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanTenureProvider>(
        builder: (context, tenureprovider, child) {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Loan Tenure in years",
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  tenureprovider.set(double.parse(value));
                  loan_tenure_controller.text =
                      tenureprovider.loan_tenure.toString() + "year";
                },
                controller: loan_tenure_controller,
              ),
              Slider(
                  value: tenureprovider.tenure,
                  max: 30,
                  min: 0,
                  divisions: 6,
                  label: tenureprovider.tenure.toString() + "years",
                  onChanged: (value) {
                    tenureprovider.set(value);
                    loan_tenure_controller.text =
                        tenureprovider.loan_tenure.toInt().toString() + "yr";
                  }),
            ],
          ),
        ),
      );
    });
  }
}
