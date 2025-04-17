import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/pages/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app/data/model/UserData.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _rePasswordVisible = false;
  bool isLoginMode = true; // Determines whether we're in login or sign-up mode

  // Function to create a new user
  void createNewUser() {
    // Check if password length is at least 6 characters
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password must be at least 6 characters long'))
      );
      return;
    }

    // Ensure passwords match
    if (passwordController.text != rePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match'))
      );
      return;
    }

    if (userNameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      dbrepository.addUser(
          userNameController.text,
          passwordController.text,
          0.0,
          false,
          false,
          true
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Main())
      );
    }
  }

  // Function to log in an existing user
  void logInUser() {
    var userDataBox = Hive.box('User');
    var existingUser = userDataBox.values.isEmpty ? null : userDataBox.values.first;
    if (existingUser != null && existingUser.password == passwordController.text) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Main())
      );
    } else {
      // Show error if login fails
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials, please try again'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(225, 149, 229, 241),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLoginMode ? "Log In" : "Create New Account",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(255, 11, 103, 195),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Enter Username:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 11, 103, 195),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Enter Password:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 11, 103, 195),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color.fromARGB(255, 11, 103, 195),
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                !isLoginMode
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Re-Enter Password:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 11, 103, 195),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: rePasswordController,
                        obscureText: !_rePasswordVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(125, 0, 0, 0),
                                  width: 2
                              )
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _rePasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color.fromARGB(255, 11, 103, 195),
                            ),
                            onPressed: () {
                              setState(() {
                                _rePasswordVisible = !_rePasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: isLoginMode ? logInUser : createNewUser,
                  child: Text(isLoginMode ? "Log In" : "Sign Up"),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = !isLoginMode;  // Toggle between login and signup
                    });
                  },
                  child: Text(
                    isLoginMode ? "Don't have an account? Sign up" : "Already have an account? Log in",
                    style: TextStyle(color: Color.fromARGB(255, 11, 103, 195)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
