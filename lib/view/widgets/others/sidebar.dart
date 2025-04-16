// ignore_for_file: prefer_const_constructors
import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/pages/start-screen.dart';
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/provider/transactionProvider.dart';
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: false);
    final tprovider = Provider.of<transactionProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Rose Lamichhane"),
            accountEmail: Text("lamixanerosee@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(),
            ),
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 178, 175, 175)),
          ),
          ListTile(
            leading: Icon(Icons.cleaning_services),
            title: Text("Wipe Data"),
            onTap: () async {
              bool val = await showDialog(
                  context: context,
                  builder: (context) {
                    return confirmBox(
                        text: "Are you sure you want to wipe all data ?");
                  });
              if (val) {
                wipeData(provider, tprovider);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Device Authentication"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notification_add),
            title: Text("Enable Notifications"),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text("Change Theme"),
            onTap: () => {},
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text("Edit User"),
              onTap: () async {
                bool val = await showDialog(
                    context: context,
                    builder: (context) {
                      return confirmBox(
                          text: "Are you sure you want to remove user ?");
                    });
                if (val) {
                  removeUser(context);
                }
              })
        ],
      ),
    );
  }
}
