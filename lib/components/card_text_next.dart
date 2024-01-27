import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget CardTextNext(
    String hintText,
    TextEditingController controller,
    Function()? onNextClick,
    Function(String) onTextChange,
    BuildContext context,
    String iconPath) {
  return SizedBox(
    height: 80,
    child: Card(
      elevation: 4,
      surfaceTintColor: const Color(0xffF2F2F2),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            cursorColor: const Color(0xff243141),
            controller: controller,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (value) {
              onTextChange(value);
            },
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
                  iconPath,
                  semanticsLabel: 'Next',
                  height: 85,
                ),
              ))
        ],
      ),
    ),
  );
}
