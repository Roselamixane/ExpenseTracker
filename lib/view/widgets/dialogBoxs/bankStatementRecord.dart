// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace

import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/widgets/buttons/DropDownBox.dart';
import 'package:app/view/widgets/others/transactionsDisplayBox.dart';
import 'package:flutter/material.dart';

class BankStatement extends StatefulWidget {
  const BankStatement({
    super.key,
    required this.selectedTotal,
    required this.selectedMonth,
    required this.selectedYear,
  });

  final bool selectedTotal;
  final String selectedYear;
  final int selectedMonth;

  @override
  State<BankStatement> createState() => _BankStatementState();
}

class _BankStatementState extends State<BankStatement> {
  List<String> Items = ["Bank1", "Bank2", "Bank3", "Other"];
  String SelectedItem = "Other";

  List<List<dynamic>> Data = [];
  void pickAndDisplayData() async {
    final filePath = await repository.pickXLSXFile();
    if (filePath != null) {
      Data = repository.parseXLSXFile(filePath);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionData(
                  data: Data,
                  account: SelectedItem,
                  selectedTotal: widget.selectedTotal,
                  selectedMonth: widget.selectedMonth,
                  selectedYear: widget.selectedYear,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Select Bank: ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropDownBox(
              items: Items,
              defaultItem: SelectedItem,
              updatedValue: (String value) {
                SelectedItem = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.lightBlue),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )),
                onPressed: pickAndDisplayData,
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
