import 'package:flutter/material.dart';

Widget TextFieldSearch(TextEditingController controller, String hintText,
    Function(String) onValueChanged) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        fillColor: const Color(0xffF2F2F2),
        filled: true,
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                  onValueChanged(controller.text);
                },
                child: const Icon(Icons.clear),
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none)),
    onChanged: (value) {
      onValueChanged(value);
    },
  );
}
