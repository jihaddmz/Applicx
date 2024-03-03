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
  String? initialSelected;

  @override
  _MyDropDown createState() => _MyDropDown();
}

class _MyDropDown extends State<MyDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          underline: const SizedBox(),
          icon: Card(
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.initialSelected ?? "...  "),
                  Image.asset(
                    "assets/images/image_dropdown.png",
                    width: 20,
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          items: widget.list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                  value.split(":").isNotEmpty ? value.split(":")[0] : value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              widget.initialSelected = value;
            });
            widget.onSelect(value);
          },
        ),
        TextGrey(widget.label)
      ],
    );
  }
}
