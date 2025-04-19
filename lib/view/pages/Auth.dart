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
    if (name.isEmpty || pass.isEmpty) return _showSnack('Username and password required');
    if (pass.length < 6) return _showSnack('Password must be at least 6 characters');
    if (pass != rePass) return _showSnack('Passwords do not match');

    final userBox = Hive.box('User');
    if (userBox.get('user') != null) return _showSnack('An account already exists');

    final user = Userdata(
      name, 0.0, false, false, pass, true,
      profileImagePath: profileImagePath,
    );
    await userBox.put('user', user);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Main()));
  }

  void logInUser() {
    final name = userNameController.text.trim();
    final pass = passwordController.text.trim();
    final userBox = Hive.box('User');
    final user = userBox.get('user') as Userdata?;
    if (user == null) return _showSnack('No account found — please sign up');
    if (user.userName == name && user.password == pass) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Main()));
    } else {
      _showSnack('Invalid credentials');
    }
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

                    if (!isLoginMode)
                      GestureDetector(
                        onTap: pickProfileImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: profileImagePath != null
                              ? FileImage(File(profileImagePath!))
                              : null,
                          backgroundColor: Colors.grey.shade200,
                          child: profileImagePath == null
                              ? const Icon(Icons.camera_alt, size: 30)
                              : null,
                        ),
                      ),

                    if (!isLoginMode) const SizedBox(height: 16),

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
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (!isLoginMode) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: rePasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Re-enter Password',
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
            ),
          ),
        ),
      ),
    );
  }
}
