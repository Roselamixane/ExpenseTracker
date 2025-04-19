import 'package:app/view/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('User');
    final userList = userBox.values.toList();
    final bool hasUsers = userList.isNotEmpty;

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 149, 229, 241),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/splashLogo1.png'),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Expense Tracker",
                  style: TextStyle(
                    color: Color.fromARGB(255, 11, 103, 195),
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Auth page (for both login and signup)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Auth(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 70),
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    hasUsers ? "Log In" : "Get Started",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
