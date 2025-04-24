import 'package:app/utils/collections.dart' as collections;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/widgets/cards/Categories.dart';
import 'package:app/view/widgets/charts/barChart.dart';
import 'package:app/view/widgets/charts/lineChart.dart';
import 'package:app/view/widgets/charts/pieChart.dart';
import 'package:app/view/widgets/others/TransactionBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';

import '../../data/model/Finance.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab({super.key});
  int _selectedIndex = 0;
  bool selectedTotal = true;
  List<String> months = collections.months;
  int currentYear = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<summaryProvider>(builder: (context, provider, child) {
      selectedTotal
          ? provider.updateDefault(0, 0)
          : provider.updateDefault(
          _selectedIndex, int.parse(provider.yearList[currentYear]));
      final userBox = Hive.box('User');
      final currentUsername = userBox.get('currentUser') as String?;
      final user = currentUsername != null ? userBox.get(currentUsername) as Userdata? : null;
      final financeBox = Hive.box<Finance>('finance'); // Finance records box

      double currentBalance = 0.0;

      // Recalculate balance based on user's finance records
      if (currentUsername != null) {
        final userFinanceRecords = financeBox.values
            .where((record) => record.user == currentUsername)
            .toList();

        for (var record in userFinanceRecords) {
          if (record.trancType == 'income') {
            currentBalance += record.amount;
          } else if (record.trancType == 'expense') {
            currentBalance -= record.amount;
          }
        }

        // Update the balance for the current user
        userBox.put(currentUsername, currentBalance);
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // User Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color.fromARGB(255, 243, 237, 247),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.userName ?? 'Guest'}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Balance: \$${currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // Card for Transaction Overview
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TransactionBox(
                            color: Colors.green,
                            value: provider.incoming,
                            type: 'Incoming',
                          ),
                          TransactionBox(
                            color: Colors.blue,
                            value: (provider.incoming + provider.outgoing),
                            type: 'Balance',
                          ),
                          TransactionBox(
                            color: Colors.red,
                            value: provider.outgoing,
                            type: 'Outgoing',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 35,
                            width: 350,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    selectedTotal = true;
                                    provider.updateValues(0, 0);
                                  },
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: selectedTotal == true
                                          ? Colors.black
                                          : const Color.fromARGB(
                                          255, 200, 202, 202),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (currentYear <
                                        (provider.yearList.length - 1)) {
                                      currentYear++;
                                      selectedTotal = false;
                                      _selectedIndex = 0;
                                      provider.updateValues(
                                          0,
                                          int.parse(
                                              provider.yearList[currentYear]));
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
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
                                        255, 200, 202, 202),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (currentYear > 0) {
                                      currentYear--;
                                      selectedTotal = false;
                                      _selectedIndex = 0;
                                      provider.updateValues(
                                          0,
                                          int.parse(
                                              provider.yearList[currentYear]));
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 350,
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
                                          _selectedIndex = i,
                                          provider.updateValues(
                                              i,
                                              int.parse(provider
                                                  .yearList[currentYear]))
                                        },
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all(
                                        selectedTotal == true
                                            ? const Color.fromARGB(255, 200, 202, 202)
                                            : _selectedIndex == i
                                            ? const Color.fromARGB(255, 0, 0, 0)
                                            : const Color.fromARGB(255, 200, 202, 202),
                                      ),
                                    ),
                                    child: Text(months[i]),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Expanded body content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Categories",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 27, 118, 192),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        mainAxisSpacing: 2,
                        children: [
                          Category(category: 'Food & Drinks', value: provider.FoodnDrinks),
                          Category(category: 'Shopping', value: provider.Shopping),
                          Category(category: 'Groceries', value: provider.Groceries),
                          Category(category: 'Medical', value: provider.Medical),
                          Category(category: 'Bills', value: provider.Bills),
                          Category(category: 'Travel', value: provider.Travel),
                          Category(category: 'Transfer', value: provider.Transfer),
                          Category(category: 'Credit Card', value: provider.CreditCard),
                          Category(category: 'Education', value: provider.Education),
                          Category(category: 'Home', value: provider.Home),
                          Category(category: 'Salary', value: provider.Salary),
                          Category(category: 'Others', value: provider.Others),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Categorical Overview",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 27, 118, 192),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Pchart(dataByCategory: provider.dataByCategory),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Daily/Monthly Overview",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 27, 118, 192),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _selectedIndex > 0 && !selectedTotal
                          ? linechart(dataByDate: provider.dataByDate)
                          : barChart(dataByMonth: provider.dataByMonth),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
