import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/pages/start-screen.dart';
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
import 'package:app/view/provider/themeProvider.dart';
import 'package:app/view/widgets/dialogBoxs/confirmationBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void wipeData(summaryProvider provider, transactionProvider tprovider) {
    provider.deleteRecords();
    provider.deleteBudgets();
    tprovider.deleteRecords();
  }

  void removeUser(BuildContext context) {
    dbrepository.removeUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StartScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: false);
    final tprovider = Provider.of<transactionProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final username = dbrepository.getUser().userName;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services),
            title: Text("Wipe Data"),
            onTap: () async {
              bool val = await showDialog(
                context: context,
                builder: (context) {
                  return confirmBox(
                      text: "Are you sure you want to wipe all data?");
                },
              );
              if (val) {
                wipeData(provider, tprovider);
              }
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.brightness_6),
            title: Text("Change Theme"),
            value: themeProvider.isDarkMode,
            onChanged: (val) {
              themeProvider.toggleTheme(val);
            },
          ),
          ListTile(
            leading: Icon(Icons.person_remove),
            title: Text("Delete User"),
            onTap: () async {
              bool val = await showDialog(
                context: context,
                builder: (context) {
                  return confirmBox(
                      text: "Are you sure you want to remove user?");
                },
              );
              if (val) {
                removeUser(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
