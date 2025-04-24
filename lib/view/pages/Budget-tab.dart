// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BudgetTab extends StatelessWidget {
  const BudgetTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<summaryProvider>(
      builder: (BuildContext context, provider, child) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.budgetRecords.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.budgetRecords.isNotEmpty) {
                        final rowData = provider.budgetRecords[index];
                        double budgetamt = (repository.getamtforBudget(
                            rowData.date,
                            rowData.trancCategory,
                            rowData.duration));
                        budgetamt = budgetamt * -1;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 0, 8),
                                        child: Icon(repository.iconForCategory(
                                            rowData.trancCategory)),
                                      ),
                                      Text(rowData.trancCategory),
                                    ],
                                  ),
                                  title: Text(rowData.duration),
                                  subtitle: Text(rowData.duration == "Monthly"
                                      ? repository.formatDate(rowData.date)[1] +
                                          " " +
                                          repository.formatDate(rowData.date)[2]
                                      : repository.formatDate(rowData.date)[2]),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        repository
                                                .formatAmount(budgetamt)
                                                .toString() +
                                            "/" +
                                            repository.formatAmount(
                                                rowData.Budget_amount),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        (rowData.Budget_amount - budgetamt)
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: rowData.Budget_amount -
                                                budgetamt <
                                                0
                                                ? Colors.red
                                                : Colors.lightGreen,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: LinearPercentIndicator(
                                    lineHeight: 20,
                                    percent: budgetamt > 0
                                        ? (budgetamt / rowData.Budget_amount) <
                                        1
                                        ? (budgetamt /
                                        rowData.Budget_amount)
                                        : 1
                                        : 0,
                                    progressColor:
                                    (budgetamt / rowData.Budget_amount) < 1
                                        ? Colors.lightGreen
                                        : Colors.red,
                                    barRadius: Radius.circular(20),
                                    center: Text((budgetamt /
                                        rowData.Budget_amount *
                                        100)
                                        .toStringAsFixed(0) +
                                        "%"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}