import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget CardTextImage(String text, String imagePath) {
  return Card(
    color: const Color(0xffF2F2F2),
    elevation: 4,
    surfaceTintColor: const Color(0xffF2F2F2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextLessBoldBlack(text),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Image.asset(imagePath),
        )
      ],
    ),
  );
}
