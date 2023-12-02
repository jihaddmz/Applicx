import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget CardTextNext(String hintText, Function()? onNextClick) {
  TextEditingController controller = TextEditingController();

  return TextField(
    controller: controller,
    style: const TextStyle(),
    decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: GestureDetector(
          onTap: onNextClick,
          child: SvgPicture.asset(
            "assets/svgs/vector_circleforward.svg",
            semanticsLabel: 'Acme Logo',
          ),
        ),
        hintText: hintText,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(100))),
  );
}
