import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  MyTextField(
      {required this.controller,
      this.fillColor = const Color(0xffF2F2F2),
      this.inputType = TextInputType.text,
      required this.hintText,
      this.showLabel = false,
      this.enabled = true,
      this.prefixIcon = const Icon(
        Icons.search,
      ),
      this.suffixIcon = const Icon(
        Icons.clear,
      ),
      required this.onValueChanged,
      this.errorText});

  final TextEditingController controller;
  final Color fillColor;
  final TextInputType inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool showLabel;
  final bool enabled;
  final Function(String) onValueChanged;
  String? errorText;

  @override
  _MyTextField createState() => _MyTextField();
}

class _MyTextField extends State<MyTextField> {
  bool _showSuffixIcon = false;

  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.isNotEmpty) {
      setState(() {
        _showSuffixIcon = true;
      });
    }

    return TextField(
      enabled: widget.enabled,
      keyboardType: widget.inputType,
      controller: widget.controller,
      decoration: InputDecoration(
          fillColor: widget.fillColor,
          filled: true,
          errorText: widget.errorText,
          hintText: widget.showLabel == false ? widget.hintText : null,
          hintStyle: const TextStyle(fontWeight: FontWeight.w100),
          labelText: widget.showLabel ? widget.hintText : null,
          prefixIcon: widget.prefixIcon,
          suffixIcon: _showSuffixIcon
              ? GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    setState(() {
                      _showSuffixIcon = false;
                    });
                    widget.onValueChanged(widget.controller.text);
                  },
                  child: widget.suffixIcon,
                )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
      onChanged: (value) {
        if (widget.errorText != null) {
          if (widget.errorText!.isNotEmpty) {
            setState(() {
              widget.errorText = null;
            });
          }
        }
        widget.onValueChanged(value);
        if (value.isNotEmpty) {
          setState(() {
            _showSuffixIcon = true;
          });
        } else {
          setState(() {
            _showSuffixIcon = false;
          });
        }
      },
    );
  }
}
