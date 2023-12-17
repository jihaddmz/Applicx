import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

class MyDropDown extends StatefulWidget {
  MyDropDown(
      {required this.list,
      required this.label,
      required this.onSelect,
      this.initialSelected});

  final List<String> list;
  final String label;
  final Function(String?) onSelect;
  final String? initialSelected;

  @override
  _MyDropDown createState() => _MyDropDown();
}

class _MyDropDown extends State<MyDropDown> {
  String? _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          underline: const SizedBox(),
          icon: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Text(_selected ?? "..."),
            ),
          ),
          items: widget.list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selected = value;
            });
            widget.onSelect(value);
          },
        ),
        TextGrey(widget.label)
      ],
    );
  }
}
