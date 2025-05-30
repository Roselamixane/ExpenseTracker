import 'package:app/utils/collections.dart' as collections;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/widgets/cards/Categories.dart';
import 'package:app/view/widgets/charts/barChart.dart';
import 'package:app/view/widgets/charts/lineChart.dart';
import 'package:app/view/widgets/charts/pieChart.dart';
import 'package:app/view/widgets/others/TransactionBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryTab extends StatelessWidget {
  SummaryTab({super.key});
  int _selectedIndex = 0;
  bool selectedTotal = true;

  List<String> months = collections.months;
  int currentYear = 0;

  @override
  Widget build(BuildContext context) {
    // Get current theme for dynamic color changes
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<summaryProvider>(builder: (context, provider, child) {
      selectedTotal
          ? provider.updateDefault(0, 0)
          : provider.updateDefault(_selectedIndex, int.parse(provider.yearList[currentYear]));

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                color: isDarkMode ? Colors.grey[800] : Colors.white,  // Adjusting card color based on theme
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
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (currentYear < (provider.yearList.length - 1)) {
                                      currentYear++;
                                      selectedTotal = false;
                                      _selectedIndex = 0;
                                      provider.updateValues(0, int.parse(provider.yearList[currentYear]));
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  provider.yearList.isNotEmpty ? provider.yearList[currentYear] : "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: selectedTotal == false
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (currentYear > 0) {
                                      currentYear--;
                                      selectedTotal = false;
                                      _selectedIndex = 0;
                                      provider.updateValues(0, int.parse(provider.yearList[currentYear]));
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
                                    onPressed: () {
                                      if (provider.yearList.isNotEmpty) {
                                        selectedTotal = false;
                                        _selectedIndex = i;
                                        provider.updateValues(i, int.parse(provider.yearList[currentYear]));
                                      }
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all(
                                        selectedTotal == true
                                            ? Colors.grey
                                            : _selectedIndex == i
                                            ? Colors.black
                                            : Colors.grey,
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode ? Colors.white : Color.fromARGB(255, 27, 118, 192),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
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
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode ? Colors.white : Color.fromARGB(255, 27, 118, 192),
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
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: isDarkMode ? Colors.white : Color.fromARGB(255, 27, 118, 192),
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
