import 'package:flutter/material.dart';

class Smallbutton extends StatelessWidget {
  const Smallbutton({super.key, required this.text, required this.function});
  final String text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function(),
      style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(Colors.lightBlue),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}