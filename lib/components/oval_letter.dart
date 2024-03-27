import 'package:flutter/material.dart';

Widget OvalLetter(String name, {Color color = const Color(0xff9ECCFA)}) {
  String firstLetter = name.characters.first;

  return CircleAvatar(
    backgroundColor: color,
    child: Text(firstLetter),
  );
}
