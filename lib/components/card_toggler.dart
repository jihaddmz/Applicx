import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

class CardToggler extends StatefulWidget {
  CardToggler(
      {required this.textLeft,
      required this.textRight,
      this.iconLeft,
      this.iconRight,
      required this.onToggle});

  final String textLeft;
  final String textRight;
  final Widget? iconLeft;
  final Widget? iconRight;
  final Function(int) onToggle;

  @override
  _CardToggler createState() => _CardToggler();
}

class _CardToggler extends State<CardToggler> with TickerProviderStateMixin {
  Color color1 = const Color(0xff243141);
  Color color2 = const Color(0xffF5F5F5);
  Color colorText1 = const Color(0xffF5F5F5);
  Color colorText2 = const Color(0xff243141);
  double elevation1 = 1;
  double elevation2 = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
      color: const Color(0xffF5F5F5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              onCard1Tap();
              widget.onToggle(0);
            },
            child: Card(
              elevation: elevation1,
              color: color1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    TextNormalBlack(widget.textLeft, color: colorText1),
                    widget.iconLeft != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: widget.iconLeft,
                          )
                        : Text("")
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onCard2Tap();
              widget.onToggle(1);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70)),
              elevation: elevation2,
              color: color2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    TextNormalBlack(widget.textRight, color: colorText2),
                    widget.iconRight != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: widget.iconRight,
                          )
                        : Text("")
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onCard1Tap() {
    setState(() {
      color1 = const Color(0xff243141);
      color2 = const Color(0xffF5F5F5);
      colorText1 = const Color(0xffF5F5F5);
      colorText2 = const Color(0xff243141);
      elevation1 = 1;
      elevation2 = 0;
    });
  }

  void onCard2Tap() {
    setState(() {
      color1 = const Color(0xffF5F5F5);
      color2 = const Color(0xff243141);
      colorText1 = const Color(0xff243141);
      colorText2 = const Color(0xffF5F5F5);
      elevation1 = 0;
      elevation2 = 1;
    });
  }
}
