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
        color: const Color.fromARGB(255, 149, 229, 241),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/splashLogo1.png',
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Expense Tracker",
                  style: TextStyle(
                      color: Color.fromARGB(255, 11, 103, 195),
                      fontWeight: FontWeight.bold,
                      fontSize: 48),
                ),
              ),
              // Image.asset(
              //   'lib/assets/images/logoName.png',
              //   width: 250
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        userExists ? const Main() : Auth()),
                  ),
                  // onPressed: () {
                  //   print("res:");
                  //   print(repository.readSms());
                  // },

                  style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(Size(250, 70)),
                      backgroundColor:
                      const WidgetStatePropertyAll(Colors.lightBlue),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                  child: Text(
                    userExists ? "Log In" : "Get Started",
                    style: TextStyle(
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