import 'package:flutter/material.dart';

Widget Button(String text, Function() onCLick,
    {Color color = const Color(0xffFF6F77)}) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
          side: const MaterialStatePropertyAll(
              BorderSide(style: BorderStyle.none)),
          backgroundColor: MaterialStatePropertyAll(color)),
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

Widget ButtonSmall(String text, Function() onCLick,
    {Color color = const Color(0xffFF6F77)}) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
          side: const MaterialStatePropertyAll(
              BorderSide(style: BorderStyle.none)),
          backgroundColor: MaterialStatePropertyAll(color)),
      onPressed: onCLick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ));
}
