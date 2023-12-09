import 'package:flutter/material.dart';

Widget TextGrey(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 16, color: Color(0xff243141), fontWeight: FontWeight.w200),
  );
}

Widget TextNormalBlack(String text, {Color? color, TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: 18,
        color: color ?? Color(0xff243141),
        fontWeight: FontWeight.w600),
  );
}

Widget TextBoldBlack(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  );
}

Widget TextLink(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationColor: Color(0xffFF6F77),
        color: Color(0xffFF6F77)),
  );
}
