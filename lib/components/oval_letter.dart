import 'package:flutter/material.dart';

Widget OvalLetter(String name) {
  String firstLetter = name.characters.first;

  return CircleAvatar(
    backgroundColor: Color(0xff9ECCFA),
    child: Text(firstLetter),
  );
}
