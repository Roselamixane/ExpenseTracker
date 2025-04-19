import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/mainScreen.dart';
import 'package:app/view/pages/start-screen.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoginMode = true;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  String? profileImagePath;

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => profileImagePath = picked.path);
  }

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
      userNameController.clear();
      passwordController.clear();
      rePasswordController.clear();
      profileImagePath = null;
    });
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

  void logInUser() {
    final name = userNameController.text.trim();
    final pass = passwordController.text.trim();
    final userBox = Hive.box('User');
    final user = userBox.get('user') as Userdata?;
    if (user == null) {
      _showSnack('No account found — please sign up');
      return;
    }
    if (user.userName == name && user.password == pass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Main()),  // <-- use Main()
      );
    } else {
      _showSnack('Invalid credentials');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLoginMode ? 'Log In' : 'Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isLoginMode) ...[
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
            ],
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
            if (!isLoginMode) ...[
              const SizedBox(height: 12),
              TextField(
                controller: rePasswordController,
                decoration: const InputDecoration(labelText: 'Re-enter Password'),
                obscureText: true,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoginMode ? logInUser : createNewUser,
              child: Text(isLoginMode ? 'Log In' : 'Sign Up'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: toggleMode,
              child: Text(isLoginMode
                  ? "Don't have an account? Sign up"
                  : "Already have one? Log in"),
            ),
            if (isLoginMode)
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const StartScreen()),
                  );
                },
                child: const Text('Back to Start'),
              ),
          ],
        ),
      ),
    );
  }
}
