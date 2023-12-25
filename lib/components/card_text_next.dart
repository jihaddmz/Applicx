import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget CardTextNext(String hintText, Function()? onNextClick) {
  TextEditingController controller = TextEditingController();

  return SizedBox(
    height: 80,
    child: Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            controller: controller,
            style: const TextStyle(),
            decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(100))),
          ),
          Positioned(
              right: -7,
              top: 0,
              child: GestureDetector(
                onTap: onNextClick,
                child: SvgPicture.asset(
                  "assets/svgs/vector_circleforward.svg",
                  semanticsLabel: 'Next',
                  height: 85,
                ),
              ))
        ],
      ),
    ),
  );
}
