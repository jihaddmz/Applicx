import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro1() {
  return Container(
    color: const Color(0xffF9CDCC),
    child: Stack(
      children: [
        Column(
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
                      "Eliminate the time wasted on credit transfer.")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "Recharge the desired amount of credits with just one click.")),
            )
          ],
        )
      ],
    ),
  );
}
