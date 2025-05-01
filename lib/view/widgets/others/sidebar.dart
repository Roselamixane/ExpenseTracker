import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/Auth.dart';
import 'package:app/view/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'convertCurrency.dart';

class Sidebar extends StatelessWidget {
  final Userdata user;
  const Sidebar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.userName),
            accountEmail: Text('${user.userName.toLowerCase()}@gmail.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 30),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // Dark mode switch
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
            ),
          ),

          const Divider(),

          // Change password
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Change Password'),
            onTap: () => _changePassword(context, user),
          ),

          // Currency Converter
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency Converter'),
            onTap: () => _showCurrencyConverterDialog(context),
          ),

          const Spacer(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: const Text('Logout'),
            onTap: () async {
              final userBox = Hive.box('User');
              await userBox.delete('currentUser');
              Fluttertoast.showToast(msg: 'Logged out');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Auth()),
                    (route) => false,
              );
            },
          ),

          // Delete account (with confirmation)
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account'),
            onTap: () => _confirmDelete(context, user),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Userdata user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
            onPressed: () async {
              final userBox = Hive.box('User');
              await userBox.delete(user.userName);
              await userBox.delete('currentUser');
              Fluttertoast.showToast(msg: 'Account deleted');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Auth()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _changePassword(BuildContext context, Userdata user) {
    final oldCtl = TextEditingController();
    final newCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Old Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final oldPass = oldCtl.text.trim();
              final newPass = newCtl.text.trim();

              if (oldPass != user.password) {
                Fluttertoast.showToast(msg: 'Old password incorrect');
                return;
              }

              if (newPass.length < 4) {
                Fluttertoast.showToast(msg: 'New password must be ≥4 characters');
                return;
              }

              user.password = newPass;
              final box = Hive.box('User');
              box.put(user.userName, user);
              box.put('currentUser', user.userName);

              Fluttertoast.showToast(msg: 'Password changed');
              Navigator.pop(context);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyConverterDialog(BuildContext context) {
    final amountController = TextEditingController();
    String fromCurrency = 'NPR';
    String toCurrency = 'USD';
    double convertedAmount = 0.0;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Currency Converter'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (e.g. 1200)',
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: fromCurrency,
                        onChanged: (String? newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                          });
                        },
                        items: ['NPR', 'USD', 'INR', 'EUR', 'GBP']
                            .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                            .toList(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.compare_arrows),
                      ),
                      DropdownButton<String>(
                        value: toCurrency,
                        onChanged: (String? newValue) {
                          setState(() {
                            toCurrency = newValue!;
                          });
                        },
                        items: ['NPR', 'USD', 'INR', 'EUR', 'GBP']
                            .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null) {
                        final result = await convertCurrency(fromCurrency, toCurrency, amount);
                        setState(() {
                          convertedAmount = result;
                        });

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: const Text('Converted Amount'),
                            content: Text(
                              '$amount $fromCurrency = ${convertedAmount.toStringAsFixed(2)} $toCurrency',
                              style: const TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(msg: 'Enter a valid amount');
                      }
                    },
                    icon: const Icon(Icons.calculate),
                    label: const Text('Convert'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
