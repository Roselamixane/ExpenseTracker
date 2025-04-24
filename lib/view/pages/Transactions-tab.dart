// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, dead_code, body_might_complete_normally_nullable, prefer_const_constructors, sized_box_for_whitespace

import 'package:app/domain/repository.dart' as repository;
import 'package:app/utils/collections.dart' as collections;
//import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/widgets/dialogBoxs/cashRecord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTab extends StatelessWidget {
  const TransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    bool selectedTotal = true;
    int currentYear = 0;
    List<String> months = collections.months;
    //List<String> yearList = repository.getYearList(dbrepository.getRecords());

    //final sprovider = Provider.of<summaryProvider>(context, listen: false);

    return Consumer<transactionProvider>(
      builder: (context, provider, child) {
        selectedTotal
            ? provider.defaultValues(0, 0)
            : provider.defaultValues(
            selectedIndex, int.parse(provider.yearList[currentYear]));
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 375,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  selectedTotal = true;
                                  provider.updateRecords(0, 0);
                                },
                                child: Text("Total",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: selectedTotal == true
                                            ? Colors.black
                                            : const Color.fromARGB(
                                            255, 200, 202, 202)))),
                            IconButton(
                                onPressed: () {
                                  if (currentYear <
                                      (provider.yearList.length - 1)) {
                                    currentYear++;
                                    selectedTotal = false;
                                    selectedIndex = 0;
                                    provider.updateRecords(
                                        0,
                                        int.parse(provider.yearList.isNotEmpty
                                            ? provider.yearList[currentYear]
                                            : 0.toString()));
                                  }
                                },
                                icon: const Icon(Icons.arrow_back)),
                            Text(
                                provider.yearList.isNotEmpty
                                    ? provider.yearList[currentYear]
                                    : "",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: selectedTotal == false
                                        ? Colors.black
                                        : const Color.fromARGB(
                                        255, 200, 202, 202))),
                            IconButton(
                                onPressed: () {
                                  if (currentYear > 0) {
                                    currentYear--;
                                    selectedTotal = false;
                                    selectedIndex = 0;
                                    provider.updateRecords(
                                        0,
                                        int.parse(provider.yearList.isNotEmpty
                                            ? provider.yearList[currentYear]
                                            : 0.toString()));
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward))
                          ],
                        ),
                      )
                    ],
                  ),
                  //Second row
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 375,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            for (int i = 0; i < months.length; i++)
                              TextButton(
                                onPressed: () => {
                                  if (provider.yearList.isNotEmpty)
                                    {
                                      selectedTotal = false,
                                      selectedIndex = i,
                                      provider.updateRecords(
                                          i,
                                          int.parse(
                                              provider.yearList[currentYear]))
                                    },
                                },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.all(
                                    selectedTotal == true
                                        ? const Color.fromARGB(
                                        255, 200, 202, 202)
                                        : selectedIndex == i
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : const Color.fromARGB(
                                        255, 200, 202, 202),
                                  ),
                                ),
                                child: Text(months[i]),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ]),
              ),

              Expanded(
                  child: ListView.builder(
                    itemCount: provider.transactionRecords.length,
                    itemBuilder: (context, index) {
                      if (provider.transactionRecords.isNotEmpty) {
                        final rowData = provider.transactionRecords[index];
                        List<String> datemonthyear =
                        repository.formatDate(rowData.date);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/images/citibank.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CashRecord(
                                                data: rowData,
                                                selectedTotal: selectedTotal,
                                                selectedYear:
                                                provider.yearList[currentYear],
                                                selectedMonth: selectedIndex,
                                              );
                                            });
                                      },
                                      child: ListTile(
                                        leading: Column(
                                          children: [
                                            Text((datemonthyear[0]),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                                datemonthyear[1].substring(0, 3) +
                                                    " " +
                                                    datemonthyear[2]
                                                        .substring(2, 4),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.black))
                                          ],
                                        ),
                                        title: Text((rowData.desc.toString()),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black)),
                                        trailing: Column(
                                          children: [
                                            Icon(
                                              repository.iconForCategory(
                                                  rowData.trancCategory),
                                              size: 30,
                                            ),
                                            Text(
                                                (repository
                                                    .formatAmount(rowData.amount)),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: rowData.amount >= 0
                                                        ? Colors.green
                                                        : Colors.red))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   ElevatedButton(
              //     child: Text("Add Bank Statement"),
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (context) {
              //           return BankStatement(
              //             selectedTotal: selectedTotal,
              //             selectedMonth: selectedIndex,
              //             selectedYear: provider.yearList.isNotEmpty
              //                 ? provider.yearList[currentYear]
              //                 : "0",
              //           );
              //         },
              //       );
              //     },
              //   ),
              //   ElevatedButton(
              //     onPressed: () => {
              //       showDialog(
              //           context: context,
              //           builder: (context) {
              //             return CashRecord(
              //               selectedTotal: selectedTotal,
              //               selectedYear: provider.yearList.isNotEmpty
              //                   ? provider.yearList[currentYear]
              //                   : "0",
              //               selectedMonth: selectedIndex,
              //             );
              //           }),
              //       provider.yearList =
              //           repository.getYearList(dbrepository.getRecords())
              //     },
              //     child: Text(
              //       "Add Cash Record",
              //     ),
              //   )
              // ]),
              // SizedBox(
              //   height: 10,
              // )
            ],
          ),
        );
      },
    );
  }
}