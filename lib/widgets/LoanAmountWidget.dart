import 'package:credit_saison_project/providers/loan_amount_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanAmountWidget extends StatelessWidget {
  TextEditingController loan_controller;
  FocusNode scopeNode;
  LoanAmountWidget({this.loan_controller, this.scopeNode});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanAmountProvider>(
        builder: (context, amountprovider, child) {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.money_rounded),
                    border: OutlineInputBorder(),
                    hintText: "Loan Amount in Lakhs"),
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  TextInputAction.done;
                },
                onSubmitted: (value) {
                  amountprovider.set(double.parse(value));
                  loan_controller.text =
                      amountprovider.loan_price.toString() + "Lakhs";
                },
                controller: loan_controller,
              ),
              Slider(
                  value: amountprovider.loan_price,
                  max: 200,
                  label: amountprovider.loan_price.toString() + "Lakhs",
                  min: 0,
                  divisions: 10,
                  onChanged: (value) {
                    amountprovider.set(value);
                    loan_controller.text =
                        amountprovider.loan_price.toInt().toString() + "L";
                  }),
            ],
          ),
        ),
      );
    });
  }
}
