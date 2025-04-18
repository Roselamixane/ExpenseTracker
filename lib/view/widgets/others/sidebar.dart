import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/start-screen.dart';
import 'package:app/view/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userDataBox = Hive.box('User');
    final user = userDataBox.get('user', defaultValue: Userdata('', 0.0, false, false, '', true));

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.userName ?? 'Guest'),
            accountEmail: Text(user?.userName ?? 'guest@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profileImagePath != null
                  ? FileImage(File(user!.profileImagePath!))
                  : null,
              child: user?.profileImagePath == null
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Change Theme'),
            onTap: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              // Implement change password functionality
              _changePassword(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _logout(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete User'),
            onTap: () {
              _deleteUser(context);
            },
          ),
        ],
      ),
    );
  }

  // Change Password Logic
  void _changePassword(BuildContext context) {
    final userDataBox = Hive.box('User');
    final user = userDataBox.get('user', defaultValue: Userdata('', 0.0, false, false, '', true));

    if (user != null) {
      // Prompt user to enter new password
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController passwordController = TextEditingController();
          return AlertDialog(
            title: const Text('Change Password'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Enter new password'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (passwordController.text.isNotEmpty) {
                    // Save the new password in Hive
                    user.password = passwordController.text;
                    userDataBox.put('user', user);
                    Fluttertoast.showToast(msg: 'Password changed successfully');
                    Navigator.pop(context);
                  }
                },
                child: const Text('Change'),
              ),
            ],
          );
        },
      );
    }
  }

  // Logout Logic (Clear user data from Hive)
  void _logout(BuildContext context) {
    final userDataBox = Hive.box('User');
    userDataBox.delete('user'); // Clear user data

    Fluttertoast.showToast(msg: 'Logged out successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()), // Redirect to start screen
    );
  }

  // Delete User (Clear all user data)
  void _deleteUser(BuildContext context) {
    final userDataBox = Hive.box('User');
    userDataBox.delete('user'); // Delete user data from Hive

    Fluttertoast.showToast(msg: 'User deleted successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()), // Redirect to start screen
    );
  }
}
