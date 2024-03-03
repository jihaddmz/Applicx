import 'package:flutter/material.dart';

Widget TextGrey(String text,
    {TextAlign textAlign = TextAlign.start,
    Color color = const Color(0xff243141), double fontSize = 16, FontStyle fontStyle = FontStyle.normal}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight.w200, fontStyle: fontStyle),
  );
}

Widget TextNormalBlack(String text, {Color? color, TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: 18,
        color: color ?? const Color(0xff243141),
        fontWeight: FontWeight.w400),
  );
}

Widget TextLessBoldBlack(String text, {Color? color, TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: 18,
        color: color ?? const Color(0xff243141),
        fontWeight: FontWeight.w600),
  );
}

Widget TextBoldBlack(String text, {TextAlign textAlign = TextAlign.start}) {
  return Text(
    text,
    textAlign: textAlign,
    style: const TextStyle(
        fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff243141)),
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

Widget TextNote(String text, {TextAlign textAlign = TextAlign.start}) {
  return Text(
    text,
    textAlign: textAlign,
    style: const TextStyle(
        fontSize: 16, color: Color(0xffE31F2B), fontWeight: FontWeight.w200),
  );
}
