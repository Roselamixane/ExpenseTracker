// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:app/view/widgets/cards/creditCard.dart';
import 'package:app/view/widgets/charts/cashFlow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview title
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Overview",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Color.fromARGB(255, 27, 118, 192),
                  ),
                ),
              ),

              // Credit card widget
              Center(child: creditCard()),

              // Cash flow title
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Cash Flow",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Color.fromARGB(255, 27, 118, 192),
                  ),
                ),
              ),

              // Cash flow chart widget
              Center(child: cashFlow()),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}