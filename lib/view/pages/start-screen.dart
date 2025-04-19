import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/pages/Auth.dart';
import 'package:app/view/pages/mainScreen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool userExists = dbrepository.userExist();
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 149, 229, 241), // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/splashLogo1.png'), // Add your logo here
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Expense Tracker",
                  style: TextStyle(
                    color: Color.fromARGB(255, 11, 103, 195), // Blue color for text
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        userExists ? const Main() : const Auth()), // Navigation to login/signup
                  ),
                  style: ButtonStyle(
                    minimumSize: const MaterialStatePropertyAll(Size(250, 70)),
                    backgroundColor: const MaterialStatePropertyAll(Colors.lightBlue), // Button color
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    userExists ? "Log In" : "Get Started", // Text depending on user existence
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
