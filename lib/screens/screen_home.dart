// ignore_for_file: use_build_context_synchronously

import 'package:applicx/components/card_text_image.dart';
import 'package:applicx/components/custom_route.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_notification.dart';
import 'package:applicx/screens/screen_buy_credits.dart';
import 'package:applicx/screens/screen_chargealfa.dart';
import 'package:applicx/screens/screen_chargetouch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome(
      {required this.walletAmount,
      required this.list,
      required this.onBellIconClick});

  @override
  _ScreenHome createState() => _ScreenHome();

  final double walletAmount;
  final List<ModelNotification> list;
  final Function onBellIconClick;
}

class _ScreenHome extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextBoldBlack("Carrier \nSelection"),
              GestureDetector(
                onTap: () {
                  widget.onBellIconClick();
                },
                child: Badge.count(
                  count: widget.list.length,
                  child: SvgPicture.asset(
                    "assets/svgs/vector_bell.svg",
                    semanticsLabel: "Settings",
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: TextNormalBlack("Specify the carrier you want"),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset("assets/images/image_chatbot.png"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MyCustomRoute((BuildContext context) {
                return ScreenChargeAlfa(
                  walletAmount: widget.walletAmount,
                );
              },
                  const RouteSettings(),
                  ScreenChargeAlfa(
                    walletAmount: widget.walletAmount,
                  )));
            },
            child: CardTextImage("Alfa", "assets/images/logo_alfa.png"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            color: Colors.black,
            thickness: 3,
            indent: 130,
            endIndent: 130,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MyCustomRoute((BuildContext context) {
                return ScreenChargeTouch(
                  walletAmount: widget.walletAmount,
                );
              },
                  RouteSettings(),
                  ScreenChargeTouch(
                    walletAmount: widget.walletAmount,
                  )));
            },
            child: CardTextImage("Touch", "assets/images/logo_touch.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextGrey("Not enough credits?"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MyCustomRoute(
                      (BuildContext context) {
                    return ScreenBuyCredits(walletAmount: widget.walletAmount);
                  }, const RouteSettings(),
                      ScreenBuyCredits(walletAmount: widget.walletAmount)));
                },
                child: TextLink("Buy Credits"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
