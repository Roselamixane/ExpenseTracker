import 'package:flutter/material.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/widgets/others/sidebar.dart';
import 'package:app/view/pages/Budget-tab.dart';
import 'package:app/view/pages/Summary-tab.dart';
import 'package:app/view/pages/Transactions-tab.dart';
import 'package:app/view/pages/home-screen.dart';

import '../widgets/dialogBoxs/addBox.dart';

class Main extends StatefulWidget {
  final Userdata currentUser; // Declare currentUser to accept data

  const Main({Key? key, required this.currentUser}) : super(key: key); // Constructor to accept currentUser

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int index = 0;

  final List<Widget> screens = [
    const Home(),
    SummaryTab(),
    const TransactionTab(),
    const BudgetTab(),
  ];

  final List<String> titles = [
    "Welcome",
    "Transaction Overview",
    "Transaction Records",
    "Budgets",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer with sidebar, passing currentUser for dynamic info
      drawer: Sidebar(user: widget.currentUser),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 237, 247),
        shadowColor: const Color.fromARGB(255, 243, 237, 247),
        elevation: 1,
        scrolledUnderElevation: 1,
        surfaceTintColor: const Color.fromARGB(255, 243, 237, 247),
        toolbarHeight: 80,
        title: Text(
          index == 0 ? "Welcome ${widget.currentUser.userName}" : titles[index], // Using currentUser here
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 27, 118, 192),
          ),
        ),
      ),
      body: screens[index], // Display the selected screen

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const Addbox(); // Example of an Add box widget
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.bar_chart_outlined, 1),
              const SizedBox(width: 10),
              _buildNavItem(Icons.history_outlined, 2),
              _buildNavItem(Icons.account_balance_wallet_outlined, 3),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation item builder for BottomAppBar
  Widget _buildNavItem(IconData icon, int itemIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = itemIndex; // Update the selected screen
        });
      },
      child: Icon(
        icon,
        size: 30,
        color: index == itemIndex
            ? const Color.fromARGB(255, 33, 150, 243)
            : Colors.grey,
      ),
    );
  }
}
