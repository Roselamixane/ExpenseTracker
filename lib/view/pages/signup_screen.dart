import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/mainScreen.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  String? profileImagePath;

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => profileImagePath = picked.path);
  }

  Future<void> createNewUser() async {
    final name = userNameController.text.trim();
    final pass = passwordController.text.trim();
    final rePass = rePasswordController.text.trim();
    if (name.isEmpty || pass.isEmpty) {
      _showSnack('Username and password required');
      return;
    }
    if (pass.length < 6) {
      _showSnack('Password must be at least 6 characters');
      return;
    }
    if (pass != rePass) {
      _showSnack('Passwords do not match');
      return;
    }

    final userBox = Hive.box('User');
    if (userBox.get('user') != null) {
      _showSnack('An account already exists');
      return;
    }

    final user = Userdata(
      name,                 // userName
      0.0,                  // balance
      false,                // deviceAuth
      false,                // notifications
      pass,                 // password
      true,                 // defaultTheme
      profileImagePath: profileImagePath,
    );

    await userBox.put('user', user);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Main()),  // <-- use Main()
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickProfileImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!))
                    : null,
                child: profileImagePath == null
                    ? const Icon(Icons.camera_alt, size: 32)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Tap to upload profile photo'),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rePasswordController,
              decoration: const InputDecoration(labelText: 'Re-enter Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: createNewUser,
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text("Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }
}
