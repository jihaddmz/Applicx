import 'package:flutter/material.dart';

Widget CardPaidStatus(
    {EdgeInsets padding = const EdgeInsets.fromLTRB(1, 1, 1, 1)}) {
  return Card(
    color: const Color(0xffAAD59E),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4))),
    child: Padding(
      padding: padding,
      child: Image.asset(
        "assets/images/image_status_paid.png",
        width: 22,
        height: 22,
      ),
    ),
  );
}
