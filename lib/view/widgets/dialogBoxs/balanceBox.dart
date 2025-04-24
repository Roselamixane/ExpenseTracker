import 'package:app/view/provider/summaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class balanceBox extends StatefulWidget {
  const balanceBox({super.key});

  @override
  State<balanceBox> createState() => _balanceBoxState();
}

class _balanceBoxState extends State<balanceBox> {
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<summaryProvider>(context, listen: false);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Input Balance Amount:"),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                final text = amountController.text;
                if (text.isNotEmpty) {
                  final double? amt = double.tryParse(text);
                  if (amt != null) {
                    provider.updateUser(amt);
                    Navigator.of(context).pop(); // ✅ Close dialog
                  }
                }
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
