import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:flutter/material.dart';

Widget CardToggler(
    String textLeft,
    String textRight,
    Color color1,
    Color color2,
    double elevation1,
    double elevation2,
    Function() onCard1Tap,
    Function() onCard2Tap) {
  double elev1 = 1;
  double elev2 = 0;

  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    color: const Color(0xffF5F5F5),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            onCard1Tap();
            elev1 = 1;
            elev2 = 0;
          },
          child: Card(
            elevation: elevation1,
            color: color1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextNormalBlack(textLeft),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onCard2Tap();
            elev1 = 0;
            elev2 = 1;
          },
          child: Card(
            elevation: elevation2,
            color: color2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextNormalBlack(textRight),
            ),
          ),
        )
      ],
    ),
  );
}
