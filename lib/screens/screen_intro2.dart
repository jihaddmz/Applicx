import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro2(Function onBackClick, BuildContext context) {
  return Container(
    width: double.maxFinite,
    height: MediaQuery.of(context).size.height,
    color: const Color(0xffAAD59E),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
              child: Image.asset(
                "assets/images/image_intro2.png",
                width: 350,
                height: 500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 00, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextBoldBlack(
                      "Instantly send gifts for Alfa and Touch.")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
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
            child: Image.asset(
              "assets/images/image_back.png",
              width: 40,
              height: 40,
            ),
          ),
        ),
      ],
    ),
  );
}
