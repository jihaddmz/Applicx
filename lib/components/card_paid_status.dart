import 'package:flutter/material.dart';

Widget CardPaidStatus(
    {EdgeInsets padding = const EdgeInsets.fromLTRB(3, 5, 5, 3)}) {
  return Card(
    color: const Color(0xffAAD59E),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15))),
    child: Padding(
      padding: padding,
      child: Image.asset("assets/images/image_status_paid.png"),
    ),
  );
}
