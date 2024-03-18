import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

Widget ScreenIntro4(BuildContext context, Function onBackClick) {
  return Container(
    width: double.maxFinite,
    height: MediaQuery.of(context).size.height,
    color: const Color(0xff9ECCFA),
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(90, 150, 0, 0),
              child: Image.asset(
                "assets/images/image_intro4.png",
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 0, 0),
              child: SizedBox(width: 335, child: TextBoldBlack("Sign In")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextNormalBlack("Login using your unique username")),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
              child: SizedBox(
                  width: 335,
                  child: TextGrey(
                      "We will share with you the specific username for your store")),
            ),
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
