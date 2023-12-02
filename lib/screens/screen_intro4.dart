import 'package:applicx/components/card_text_next.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/screens/screen_main.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro4(BuildContext context, Function onBackClick) {
  return Container(
    width: double.maxFinite,
    color: const Color(0xff9ECCFA),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 100, 0, 0),
              child: Image.asset("assets/images/image_intro4.png"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: SizedBox(width: 335, child: TextBoldBlack("Sign In")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextNormalBlack("Login using your unique username")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "We will share with you the specific username for your store")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: CardTextNext("Enter your username", () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ScreenMain();
                }));
              }),
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
