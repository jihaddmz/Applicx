import 'package:flutter/material.dart';

Widget CardUnPaidStatus(
    {EdgeInsets padding = const EdgeInsets.fromLTRB(1, 1, 1, 1)}) {
  return Card(
    color: const Color(0xffE11F2B),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4))),
    child: Padding(
      padding: padding,
      child: Image.asset(
        "assets/images/image_status_unpaid.png",
        width: 22,
        height: 22,
      ),
    ),
  );
}
