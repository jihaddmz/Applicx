import 'package:flutter/material.dart';

Widget TextFieldBorder(
    {required TextEditingController controller,
    required bool enabled,
    required String label}) {
  return TextField(
    cursorColor: const Color(0xff243141),
    controller: controller,
    enabled: enabled,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff243141), width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff243141), width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff243141), width: 1)),
      labelText: label,
      labelStyle: const TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black),
    ),
  );
}
