import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro1() {
  return Container(
    width: double.maxFinite,
    color: const Color(0xffF9CDCC),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
          child: Image.asset("assets/images/image_intro1.png"),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: SizedBox(
              width: 335,
              child: TextBoldBlack(
                  "Reduce the time spent on transferring credits.")),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: SizedBox(
              width: 335,
              child: TextGrey(
                  "Refill your chosen credit amount easily by clicking just once.")),
        )
      ],
    ),
  );
}
