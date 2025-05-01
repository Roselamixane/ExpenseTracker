import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app/data/model/Finance.dart';
import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/widgets/dialogBoxs/budgetRecord.dart';
import 'package:app/view/widgets/dialogBoxs/cashRecord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/data/repository/dbRepository.dart' as dbrepository;

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

  Future<void> importCsv(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();
      final rows = const CsvToListConverter().convert(csvString, eol: '\n');

      for (var i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          final trancType = row[0].toString(); // Income/Expense
          final date = DateTime.parse(row[1].toString());
          final desc = row[2].toString();
          final category = row[3].toString();
          double amount = double.parse(row[4].toString());

          if (trancType == "Expense") {
            amount *= -1;
          }

          final finance = Finance(" ", " ", date, desc, trancType, category, amount);
          dbrepository.addRecord(finance);
        } catch (e) {
          debugPrint("Error parsing row $i: $e");
        }
      }

      // Update UI
      final provider = Provider.of<summaryProvider>(context, listen: false);
      final tprovider = Provider.of<transactionProvider>(context, listen: false);
      action(provider, tprovider, true, 0, "0");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CSV import complete.")),
      );
    }
  }

  Future<double> predictNextMonthExpense(BuildContext context) async {
    final tprovider = Provider.of<transactionProvider>(context, listen: false);
    final transactionRecords = tprovider.transactionRecords;
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, 1);

    final recentExpenses = transactionRecords.where((tx) =>
    tx.trancType == "Expense" && tx.date.isAfter(threeMonthsAgo)).toList();

    double total = recentExpenses.fold(0, (sum, item) => sum + item.amount);
    return recentExpenses.isNotEmpty ? total / 3 : 0;
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
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CashRecord(
                    data: Finance("", "", DateTime.now(), "", "", "", 0.00),
                    selectedTotal: true,
                    selectedYear: "0",
                    selectedMonth: 0,
                  ),
                );
              },
              child: const Text("Add Cash Record", style: TextStyle(color: Colors.white)),
              style: _buttonStyle(),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const BudgetDialog(),
                );
              },
              child: const Text("Add new Budget", style: TextStyle(color: Colors.white)),
              style: _buttonStyle(),
            ),
            ElevatedButton(
              onPressed: () async {
                final prediction = await predictNextMonthExpense(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("AI Prediction"),
                    content: Text("Estimated total expense for next month: ₹${prediction.toStringAsFixed(2)}"),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                  ),
                );
              },
              child: const Text("Predict Next Month's Expense", style: TextStyle(color: Colors.white)),
              style: _buttonStyle(),
            ),
            ElevatedButton(
              onPressed: () => importCsv(context),
              child: const Text("Import Past Records from CSV", style: TextStyle(color: Colors.white)),
              style: _buttonStyle(),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.lightBlue),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
