// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:app/data/model/Finance.dart';
import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/utils/collections.dart' as collections;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/widgets/buttons/DropDownBox.dart';
import 'package:app/view/widgets/buttons/datePicker.dart';
import 'package:app/view/widgets/dialogBoxs/alertBox.dart';
import 'package:app/view/widgets/dialogBoxs/confirmationBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashRecord extends StatefulWidget {
  const CashRecord(
      {super.key,
      required this.data,
      required this.selectedTotal,
      required this.selectedYear,
      required this.selectedMonth});
  final bool selectedTotal;
  final String selectedYear;
  final int selectedMonth;
  final Finance data;

  @override
  State<CashRecord> createState() => _CashRecordState();
}

class _CashRecordState extends State<CashRecord> {
  List<String> Categories = collections.Categories;
  String SelectedCategory = collections.Categories.first;
  List<String> Transaction = ["Income", "Expense"];
  String SelectedTranc = "Expense";

  void addCashRecord(String tranc, DateTime date, String desc, String category,
      double amount) {
    if (tranc == "Expense") {
      amount = amount * -1;
    }
    var finance = Finance(" ", " ", date, desc, tranc, category, amount);
    dbrepository.addRecord(finance);
  }

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
    bool selectedTotal = widget.selectedTotal;
    String selectedYear = widget.selectedYear;
    int selectedMonth = widget.selectedMonth;

    SelectedTranc =
        widget.data.amount == 0.00 ? "Expense" : widget.data.trancType;
    SelectedCategory =
        widget.data.amount == 0.00 ? "Others" : widget.data.trancCategory;
    Finance data = widget.data;

    TextEditingController dateController = TextEditingController(
        text: data.amount == 0.00
            ? DateTime.now().toString()
            : data.date.toString());
    TextEditingController descController =
        TextEditingController(text: data.amount == 0.00 ? "" : data.desc);
    TextEditingController amountController = TextEditingController(
        text: data.amount == 0.00
            ? ""
            : (data.amount < 0 ? data.amount * -1 : data.amount).toString());

    final provider = Provider.of<summaryProvider>(context, listen: false);
    final tprovider = Provider.of<transactionProvider>(context, listen: false);

    return Dialog(
      backgroundColor: const Color.fromARGB(255, 243, 237, 247),
      elevation: 2,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                data.amount == 0.00 ? "Add new Record" : "Edit Record",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Transaction:"),
                    DropDownBox(
                      items: Transaction,
                      defaultItem:
                          data.amount == 0.00 ? SelectedTranc : data.trancType,
                      updatedValue: (String value) {
                        SelectedTranc = value;
                      },
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:"),
                  Datepicker(
                    dateController: dateController,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Description:"),
                    SizedBox(
                        height: 50,
                        width: 150,
                        child: TextField(
                          controller: descController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(125, 0, 0, 0),
                                      width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(125, 0, 0, 0),
                                      width: 2))),
                        ))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category:"),
                    DropDownBox(
                      items: Categories,
                      defaultItem: data.amount == 0.00
                          ? SelectedCategory
                          : data.trancCategory,
                      updatedValue: (String value) {
                        SelectedCategory = value;
                      },
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount:"),
                    SizedBox(
                        height: 50,
                        width: 150,
                        child: TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(125, 0, 0, 0),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(125, 0, 0, 0),
                                        width: 2)))))
                  ]),
            ),
            data.amount == 0.00
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.lightBlue),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                      onPressed: () async {
                        (amountController.text.isEmpty ||
                                double.parse(amountController.text) <= 0.0)
                            ? await showDialog(
                                context: context,
                                builder: (context) {
                                  return alertBox();
                                })
                            : {
                                addCashRecord(
                                    SelectedTranc,
                                    DateTime.parse(dateController.text),
                                    descController.text,
                                    SelectedCategory,
                                    double.parse(amountController.text)),
                                action(provider, tprovider, selectedTotal,
                                    selectedMonth, selectedYear),
                                Navigator.pop(context)
                              };
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                  Colors.lightBlue),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              )),
                          onPressed: () async {
                            (amountController.text.isEmpty ||
                                    double.parse(amountController.text) <= 0.0)
                                ? await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return alertBox();
                                    })
                                : {
                                    addCashRecord(
                                        SelectedTranc,
                                        DateTime.parse(dateController.text),
                                        descController.text,
                                        SelectedCategory,
                                        double.parse(amountController.text)),
                                    action(provider, tprovider, selectedTotal,
                                        selectedMonth, selectedYear),
                                    Navigator.pop(context)
                                  };
                          },
                          child: Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                  Colors.lightBlue),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              )),
                          onPressed: () async {
                            bool val = await showDialog(
                                context: context,
                                builder: (context) {
                                  return confirmBox(
                                    text:
                                        "Are you sure you want to delete the Record?",
                                  );
                                });
                            if (val) {
                              dbrepository.deleteRecord(data.desc);
                              Navigator.pop(context);
                              action(provider, tprovider, selectedTotal,
                                  selectedMonth, selectedYear);
                            }
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
          ]),
    );
  }
}
