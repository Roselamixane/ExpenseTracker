import 'package:app/view/provider/summaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class balanceBox extends StatefulWidget {
  const balanceBox({super.key});

  @override
  State<balanceBox> createState() => _balanceBoxState();
}

TextEditingController amount = new TextEditingController();

void updateBalance(summaryProvider provider, String amount) {
  if (amount.isNotEmpty) {
    double amt = double.parse(amount);
    provider.updateUser(amt);
  }
}

class _balanceBoxState extends State<balanceBox> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: true);
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Input Balance Amount:"),
          TextField(
            controller: amount,
          ),
          ElevatedButton(
              onPressed: () {
                updateBalance(provider, amount.text);
              },
              child: Text("Update")),
        ],
      ),
    );
  }
}
