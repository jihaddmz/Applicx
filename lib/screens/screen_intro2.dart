import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro2(Function onBackClick) {
  return Container(
    width: double.maxFinite,
    color: const Color(0xffAAD59E),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 200, 0, 0),
              child: Image.asset("assets/images/image_intro2.png"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextBoldBlack(
                      "Instantly send gifts for Alfa and Touch.")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "Deliver the gift to the recipient without the need for any SMS.")),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
          child: GestureDetector(
            onTap: () {
              onBackClick();
            },
            child: Image.asset("assets/images/image_back.png"),
          ),
        ),
      ],
    ),
  );
}
