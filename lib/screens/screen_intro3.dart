import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro3(Function onBackClick, BuildContext context) {
  return Container(
    width: double.maxFinite,
    height: MediaQuery.of(context).size.height,
    color: const Color(0xffFDD848),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 150, 0, 0),
              child: Image.asset(
                "assets/images/image_intro3.png",
                width: 350,
                height: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextBoldBlack(
                      "No need to remember whether the user paid or not.")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "Verify whether the user has made the necessary payment.")),
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
