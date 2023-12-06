import 'package:flutter/material.dart';

Widget Button(String text, Function() onCLick) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
          side: const MaterialStatePropertyAll(
              BorderSide(style: BorderStyle.none)),
          backgroundColor: const MaterialStatePropertyAll(Color(0xffFF6F77))),
      onPressed: onCLick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ));
}
