import 'package:app/data/repository/dbRepository.dart' as dbrepository;
import 'package:app/view/pages/mainScreen.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userName = new TextEditingController();
    TextEditingController password = new TextEditingController();
    TextEditingController rePassword = new TextEditingController();

    void createNewUser() {
      if (userName.text.isNotEmpty && password.text.isNotEmpty) {
        dbrepository.addUser(
            userName.text, password.text, 0, false, false, true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Main()));
      }
    }

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
                  "Create new account",
                  style: TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(255, 11, 103, 195),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Enter UserName:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 11, 103, 195),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: userName,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2))),
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
                        controller: password,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2))),
                      ),
                    ],
                  ),
                ),
                Padding(
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
                        controller: rePassword,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(125, 0, 0, 0),
                                    width: 2))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      createNewUser();
                    },
                    child: Text("Sign up"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}