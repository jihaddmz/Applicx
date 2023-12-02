import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro3(Function onBackClick) {
  return Container(
    width: double.maxFinite,
    color: const Color(0xffFDD848),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 100, 0, 0),
              child: Image.asset("assets/images/image_intro3.png"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextBoldBlack(
                      "No need to remember the user payment status")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "Check if the user has paid the required amount")),
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
