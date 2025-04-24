import 'package:flutter/material.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({super.key, required this.dateController});
  final TextEditingController dateController;

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  @override
  Widget build(BuildContext context) {
    Future<void> selectDate() async {
      DateTime? select = await showDatePicker(
          context: context,
          currentDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2500));

      if (select != null) {
        setState(() {
          widget.dateController.text = select.toString();
        });
      }
    }

    return SizedBox(
        height: 50,
        width: 150,
        child: TextField(
          controller: widget.dateController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(125, 0, 0, 0), width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(125, 0, 0, 0), width: 2))),
          onTap: () {
            selectDate();
          },
        ));
  }
}