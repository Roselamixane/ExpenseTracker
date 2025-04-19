import 'package:app/view/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/mainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

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
      appBar: AppBar(title: const Text('Log In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: logInUser,
              child: const Text('Log In'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpPage()),
                );
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
