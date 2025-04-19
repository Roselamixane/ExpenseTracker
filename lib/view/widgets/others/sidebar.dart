import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/Auth.dart';
import 'package:app/view/provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userBox = Hive.box('User');
    final user = userBox.get('currentUser') as Userdata?;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.userName ?? 'Guest'),
            accountEmail: Text(
              user != null
                  ? '${user.userName.toLowerCase()}@example.com'
                  : 'guest@example.com',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profileImagePath != null
                  ? FileImage(File(user!.profileImagePath!))
                  : null,
              child: user?.profileImagePath == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
          ),
          SwitchListTile(
            value: themeProvider.isDarkMode,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.brightness_6),
            onChanged: themeProvider.toggleTheme,
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('Change Password'),
            onTap: () => _changePassword(context, user),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final box = Hive.box('User');
              await box.delete('currentUser'); // only log out
              Fluttertoast.showToast(msg: 'Logged out');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Auth()),
                    (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete Account'),
            onTap: () async {
              final box = Hive.box('User');
              await box.delete('user'); // delete account
              await box.delete('currentUser'); // log out
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

  void _changePassword(BuildContext context, Userdata? user) {
    if (user == null) return;
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
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final oldPass = oldCtl.text.trim();
              final newPass = newCtl.text.trim();

              if (oldPass != user.password) {
                Fluttertoast.showToast(msg: 'Old password incorrect');
                return;
              }

              if (newPass.length < 4) {
                Fluttertoast.showToast(
                    msg: 'New password must be ≥4 characters');
                return;
              }

              user.password = newPass;
              final box = Hive.box('User');
              box.put('user', user);
              box.put('currentUser', user);

              Fluttertoast.showToast(msg: 'Password changed');
              Navigator.pop(context);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
