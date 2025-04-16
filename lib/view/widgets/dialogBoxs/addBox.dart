import 'package:app/data/model/Finance.dart';
import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/widgets/dialogBoxs/bankStatementRecord.dart';
import 'package:app/view/widgets/dialogBoxs/budgetRecord.dart';
import 'package:app/view/widgets/dialogBoxs/cashRecord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addbox extends StatelessWidget {
  const Addbox({super.key});

  void action(summaryProvider provider, transactionProvider tprovider,
      bool selectedTotal, int selectedMonth, String selectedYear) {
    provider.updateValues(0, 0);
    provider.updateRecords();
    if (selectedTotal) {
      tprovider.updateRecords(0, 0);
    } else {
      tprovider.updateRecords(selectedMonth, int.parse(selectedYear));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: false);
    final tprovider = Provider.of<transactionProvider>(context, listen: false);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const BankStatement(
                        selectedTotal: true,
                        selectedMonth: 0,
                        selectedYear: "0",
                      );
                    },
                  );
                },
                style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.lightBlue),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                child: const Text(
                  "Add Bank statement",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CashRecord(
                            data: Finance(
                                "", "", DateTime.now(), "", "", "", 0.00),
                            selectedTotal: true,
                            selectedYear: "0",
                            selectedMonth: 0,
                          );
                        });
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.lightBlue),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  child: const Text(
                    "Add Cash Record",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const BudgetDialog();
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.lightBlue),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  child: const Text(
                    "Add new Budget",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () async {
                    await {
                      repository.addRecordFromMsg(provider, tprovider),
                    };
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.lightBlue),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  child: const Text(
                    "Add Record via sms",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
