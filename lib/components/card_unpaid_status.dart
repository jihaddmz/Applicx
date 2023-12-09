import 'package:flutter/material.dart';

Widget CardUnPaidStatus(
    {EdgeInsets padding = const EdgeInsets.fromLTRB(3, 5, 5, 3)}) {
  return Card(
    color: const Color(0xffE11F2B),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15))),
    child: Padding(
      padding: padding,
      child: Image.asset("assets/images/image_status_unpaid.png"),
    ),
  );
}
