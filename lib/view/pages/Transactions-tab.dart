import 'package:app/domain/repository.dart' as repository;
import 'package:app/utils/collections.dart' as collections;
import 'package:app/view/widgets/dialogBoxs/cashRecord.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/view/provider/transactionProvider.dart';

class TransactionTab extends StatelessWidget {
  const TransactionTab({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    bool selectedTotal = true;
    int currentYear = 0;
    List<String> months = collections.months;

    return Consumer<transactionProvider>(builder: (context, provider, child) {
      selectedTotal
          ? provider.defaultValues(0, 0)
          : provider.defaultValues(
          selectedIndex, int.parse(provider.yearList[currentYear]));
      final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Check for dark mode

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: isDarkMode ? Colors.grey[850] : Colors.white, // Dynamic card color
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
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: selectedTotal == true
                                        ? (isDarkMode
                                        ? Colors.white
                                        : Colors.black)
                                        : (isDarkMode
                                        ? Colors.grey[400]
                                        : Color.fromARGB(255, 200, 202, 202))),
                              )),
                          IconButton(
                              onPressed: () {
                                if (currentYear < (provider.yearList.length - 1)) {
                                  currentYear++;
                                  selectedTotal = false;
                                  selectedIndex = 0;
                                  provider.updateRecords(0,
                                      int.parse(provider.yearList.isNotEmpty
                                          ? provider.yearList[currentYear]
                                          : '0'));
                                }
                              },
                              icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black)),
                          Text(
                            provider.yearList.isNotEmpty
                                ? provider.yearList[currentYear]
                                : "",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: selectedTotal == false
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : (isDarkMode
                                  ? Colors.grey[400]
                                  : Color.fromARGB(255, 200, 202, 202)),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (currentYear > 0) {
                                  currentYear--;
                                  selectedTotal = false;
                                  selectedIndex = 0;
                                  provider.updateRecords(0,
                                      int.parse(provider.yearList.isNotEmpty
                                          ? provider.yearList[currentYear]
                                          : '0'));
                                }
                              },
                              icon: Icon(Icons.arrow_forward, color: isDarkMode ? Colors.white : Colors.black))
                        ],
                      ),
                    )
                  ],
                ),
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
                              onPressed: () {
                                if (provider.yearList.isNotEmpty) {
                                  selectedTotal = false;
                                  selectedIndex = i;
                                  provider.updateRecords(i,
                                      int.parse(provider.yearList[currentYear]));
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                  selectedTotal == true
                                      ? (isDarkMode
                                      ? Colors.grey[400]
                                      : Color.fromARGB(255, 200, 202, 202))
                                      : selectedIndex == i
                                      ? (isDarkMode ? Colors.white : Colors.black)
                                      : (isDarkMode
                                      ? Colors.grey[400]
                                      : Color.fromARGB(255, 200, 202, 202)),
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
                      List<String> datemonthyear = repository.formatDate(rowData.date);

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                        child: Card(
                          elevation: 2,
                          color: isDarkMode ? Colors.grey[850] : Colors.white, // Card color for dark mode
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
                                              selectedYear: provider.yearList[currentYear],
                                              selectedMonth: selectedIndex,
                                            );
                                          });
                                    },
                                    child: ListTile(
                                      leading: Column(
                                        children: [
                                          Text(
                                            (datemonthyear[0]),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            datemonthyear[1].substring(0, 3) +
                                                " " +
                                                datemonthyear[2].substring(2, 4),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        (rowData.desc.toString()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      trailing: Column(
                                        children: [
                                          Icon(
                                            repository.iconForCategory(rowData.trancCategory),
                                            size: 30,
                                            color: isDarkMode ? Colors.white : Colors.black, // Icon color for dark mode
                                          ),
                                          Text(
                                            (repository.formatAmount(rowData.amount)),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: rowData.amount >= 0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
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
                    return Container(); // Default container if no data
                  },
                )),
          ],
        ),
      );
    });
  }
}
