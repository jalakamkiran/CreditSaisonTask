import 'dart:math';

import 'package:credit_saison_project/providers/calculation_provider.dart';
import 'package:credit_saison_project/providers/loan_amount_provider.dart';
import 'package:credit_saison_project/providers/loan_intrest_rate_provider.dart';
import 'package:credit_saison_project/providers/loan_tenure_provider.dart';
import 'package:credit_saison_project/widgets/LoanAmountWidget.dart';
import 'package:credit_saison_project/widgets/LoanIntrestWidget.dart';
import 'package:credit_saison_project/widgets/LoanTenureWidget.dart';
import 'package:credit_saison_project/widgets/PieChartPlotter.dart';
import 'package:data_tables/data_tables.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CreditSaison());
}

class CreditSaison extends StatelessWidget {
  TextEditingController loan_controller;
  TextEditingController intrest_controller;
  TextEditingController tenure_controller;
  FocusNode scopeNode;
  @override
  Widget build(BuildContext context) {
    scopeNode = FocusScopeNode();
    NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
    loan_controller = TextEditingController();
    intrest_controller = TextEditingController(text: "5.0");
    tenure_controller = TextEditingController();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoanTenureProvider()),
        ChangeNotifierProvider(create: (context) => LoanInterestRateProvider()),
        ChangeNotifierProvider(create: (context) => LoanAmountProvider()),
        ChangeNotifierProvider(create: (context) => Calculation_Provider()),
      ],
      builder: (conetxt, child) {
        return MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Credit Saison EMI Calculator App",
                      style: TextStyle(fontSize: 20),
                    ),
                    LoanAmountWidget(
                      scopeNode: scopeNode,
                      loan_controller: loan_controller,
                    ),
                    LoanIntrestWidget(
                      scopeNode: scopeNode,
                      intrest_controller: intrest_controller,
                    ),
                    LoanTenureWidget(
                      loan_tenure_controller: tenure_controller,
                    ),
                    Consumer4<LoanTenureProvider, LoanInterestRateProvider,
                        LoanAmountProvider, Calculation_Provider>(
                      builder: (context,
                          loantenurenotifer,
                          loaninterestnotifier,
                          loanamountnotifier,
                          calculationnotifier,
                          child) {
                        return Column(
                          children: [
                            DisplayRowBuilder(
                                "Loan EMI",
                                numberFormat.format(calculationnotifier
                                    .loan_emi_price
                                    .round())),
                            DisplayRowBuilder(
                                "Total Interest Amount Payable",
                                numberFormat.format(calculationnotifier
                                    .total_interest_amount
                                    .round())),
                            DisplayRowBuilder(
                                "Total Amount Payable",
                                numberFormat.format(calculationnotifier
                                    .total_amount_payable
                                    .round())),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      calculationnotifier.set_loan_emi_price(
                                          interest:
                                              loaninterestnotifier.intrest,
                                          principle_amount:
                                              loanamountnotifier.loan_amount,
                                          tenure: loantenurenotifer.loan_tenure
                                              .toInt());
                                    },
                                    child: Text("Calculate")),
                                ElevatedButton(
                                    onPressed: () {
                                      loan_controller.text = "0";
                                      tenure_controller.text = "0";
                                      intrest_controller.text = "5.0";
                                      loantenurenotifer.set(0);
                                      loaninterestnotifier.set(5.0);
                                      loanamountnotifier.set(0);
                                      calculationnotifier.reset_all();
                                    },
                                    child: Text("Reset")),
                              ],
                            ),
                            PieChartPlotter(),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.grey),
                                columns: [
                                  DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  DataColumn(
                                    label: Text('Total Payment(Rs)',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  DataColumn(
                                    label: Text('Balance(Rs)',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  DataColumn(
                                    label: Text('Percentage loan Paid(%)',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ],
                                rows: datarowlistgenerator(
                                    ["Sept", "Oct", "Nov", "Dec"],
                                    numberFormat,
                                    calculationnotifier.loan_emi_price,
                                    loaninterestnotifier.interest_rate,
                                    loanamountnotifier.loan_price,
                                    loantenurenotifer.loan_tenure.toInt()),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Padding DisplayRowBuilder(String title, String content) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            content + " Rs",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  double calculate_balance_amount(
      double emi_amount, int months, double interest, double principle) {
    double n = interest / 12 / 100;
    double interest_amount = n * (principle * 100000);
    double princi_amount_post_interest = emi_amount - interest_amount;
    double balance = (principle * 100000) - princi_amount_post_interest;
    return balance;
  }

  double calculate_loan_complete_percent(double paid_loan, double total_loan) {
    double percent =
        (((total_loan * 100000) - paid_loan) / (total_loan * 100000)) * 100;
    return percent;
  }

  List<DataRow> datarowlistgenerator(
      List<String> titles,
      NumberFormat numberFormat,
      double emi_price,
      double interest_rate,
      double loan_price,
      int total_tenture) {
    double perm_loan_price = loan_price;
    return List.generate(titles.length, (index) {
      double tmp_loan_price = loan_price;

      tmp_loan_price =
          calculate_balance_amount(emi_price, 4, interest_rate, loan_price);
      loan_price = tmp_loan_price / 100000;
      return DataRow(cells: [
        DataCell(
          Text("10th ${titles[index]} 2021"),
        ),
        DataCell(Text(numberFormat.format(emi_price.round()))),
        DataCell(Text(numberFormat.format(tmp_loan_price.round()))),
        DataCell(Text(
            calculate_loan_complete_percent(tmp_loan_price, perm_loan_price)
                .toStringAsFixed(2))),
      ]);
    });
  }

  DataRow data_row_builder(String title, NumberFormat numberFormat,
      double emi_price, double interest_rate, double loan_price) {
    return DataRow(cells: [
      DataCell(
        Text(title),
      ),
      DataCell(Text(numberFormat.format(emi_price))),
      DataCell(Text(numberFormat.format(
          calculate_balance_amount(emi_price, 4, interest_rate, loan_price)))),
      DataCell(Text(numberFormat.format(calculate_loan_complete_percent(
          calculate_balance_amount(emi_price, 4, interest_rate, loan_price),
          loan_price)))),
    ]);
  }
}
