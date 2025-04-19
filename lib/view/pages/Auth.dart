import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';
import 'package:app/view/pages/mainScreen.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLoginMode = true;
  bool isPasswordVisible = false;
  bool isRePasswordVisible = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
      userNameController.clear();
      passwordController.clear();
      rePasswordController.clear();
    });
  }

  Future<void> createNewUser() async {
    final name = userNameController.text.trim();
    final pass = passwordController.text.trim();
    final rePass = rePasswordController.text.trim();

    if (name.isEmpty || pass.isEmpty) return _showSnack('Username and password required');
    if (pass.length < 6) return _showSnack('Password must be at least 6 characters');
    if (pass != rePass) return _showSnack('Passwords do not match');

    final userBox = Hive.box('User');
    if (userBox.containsKey(name)) {
      return _showSnack('Username already taken. Try another one.');
    }

    final user = Userdata(name, pass, 0.0, false, true, false);
    await userBox.put(name, user);
    await userBox.put('currentUser', name);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Main()));
  }

  void logInUser() {
    final name = userNameController.text.trim();
    final pass = passwordController.text.trim();

    final userBox = Hive.box('User');
    if (!userBox.containsKey(name)) {
      return _showSnack('No account found with that username');
    }

    final user = userBox.get(name) as Userdata;
    if (user.password != pass) {
      return _showSnack('Incorrect password');
    }

    userBox.put('currentUser', name);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Main()));
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final themeBlue = const Color.fromARGB(255, 11, 103, 195);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 229, 241),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/assets/images/splashLogo1.png',
                      height: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isLoginMode ? 'Log In' : 'Sign Up',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: themeBlue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (!isLoginMode) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: rePasswordController,
                        obscureText: !isRePasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Re-enter Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isRePasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isRePasswordVisible = !isRePasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoginMode ? logInUser : createNewUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 55),
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isLoginMode ? 'Log In' : 'Sign Up',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: toggleMode,
                      child: Text(
                        isLoginMode
                            ? "Don't have an account? Sign up"
                            : "Already have one? Log in",
                        style: TextStyle(color: themeBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
