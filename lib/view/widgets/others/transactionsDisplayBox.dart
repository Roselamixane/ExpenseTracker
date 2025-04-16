// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable, prefer_if_null_operators

import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionData extends StatelessWidget {
  const TransactionData({
    super.key,
    required this.data,
    required this.account,
    required this.selectedTotal,
    required this.selectedMonth,
    required this.selectedYear,
  });
  final List<List<dynamic>> data;
  final account;
  final bool selectedTotal;
  final String selectedYear;
  final int selectedMonth;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: false);
    final tprovider = Provider.of<transactionProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final rowData = data[index];
                  return Card(
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: Text((rowData[0].toString()),
                          textAlign: TextAlign.center,
                          style: index == 0
                              ? const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              : const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                      title: Text((rowData[1].toString()),
                          textAlign: TextAlign.center,
                          style: index == 0
                              ? const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              : const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                      trailing: Text(
                          (rowData[4] == null ? "0" : rowData[4].toString()) +
                              "   " +
                              (rowData[5] == null
                                  ? "0"
                                  : rowData[5].toString()),
                          textAlign: TextAlign.center,
                          style: index == 0
                              ? const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              : const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      dbrepository.addRecords(data, account);
                      provider.updateValues(0, 0);
                      provider.updateRecords();
                      if (selectedTotal) {
                        tprovider.updateRecords(0, 0);
                      } else {
                        tprovider.updateRecords(
                            selectedMonth, int.parse(selectedYear));
                      }

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.black),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
