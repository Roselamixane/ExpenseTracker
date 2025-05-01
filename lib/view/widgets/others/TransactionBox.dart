import 'package:app/domain/repository.dart' as repository;
import 'package:app/utils/screensize.dart' as screen;
import 'package:flutter/material.dart';

class TransactionBox extends StatelessWidget {
  const TransactionBox(
      {super.key,
      required this.color,
      required this.value,
      required this.type});
  final Color color;
  final double value;

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen.getTextBoxWidth(context),
      height: 85,
      child: Column(
        children: [
          Container(
            width: screen.getTextBoxWidth(context),
            height: screen.getTextBoxHeight(context),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(repository.formatAmount(value),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            width: screen.getTextBoxWidth(context),
            height: screen.getTextBoxHeight(context) / 2,
            child: Center(
              child: Text(type, style: TextStyle(color: color)),
            ),
          ),
        ],
      ),
    );
  }
}