import 'package:flutter/material.dart';

class DropDownBox extends StatefulWidget {
  const DropDownBox(
      {super.key,
        required this.items,
        required this.defaultItem,
        required this.updatedValue});
  final List<String> items;
  final String defaultItem;
  final Function(String) updatedValue;

  @override
  State<DropDownBox> createState() => _DropDownBoxState();
}

class _DropDownBoxState extends State<DropDownBox> {
  String selectedItem = "";
  @override
  Widget build(BuildContext context) {
    List<String> items = widget.items;
    String defaultItem = widget.defaultItem;
    return Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          border:
          Border.all(color: const Color.fromARGB(125, 0, 0, 0), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButton(
          borderRadius: BorderRadius.circular(15),
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          isExpanded: true,
          value: selectedItem == "" ? defaultItem : selectedItem,
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (item) => {
            setState(() => selectedItem = item!),
            widget.updatedValue(selectedItem)
          },
        ));
  }
}