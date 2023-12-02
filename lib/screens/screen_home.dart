import 'package:applicx/components/card_text_image.dart';
import 'package:applicx/components/custom_route.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/screens/screen_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget ScreenHome(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextBoldBlack("Carrier Selection"),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MyCustomRoute((BuildContext context) {
                return ScreenNotifications();
              }, RouteSettings(), ScreenNotifications()));
            },
            child: Badge.count(
              count: 2,
              child: SvgPicture.asset(
                "assets/svgs/vector_bell.svg",
                semanticsLabel: "Settings",
              ),
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 32),
        child: TextGrey("Specify the carrier you want"),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Image.asset("assets/images/image_chatbot.png"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: CardTextImage("Alfa", "assets/images/logo_alfa.png"),
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
        child: CardTextImage("Touch", "assets/images/logo_touch.png"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [TextGrey("Not enough credits?"), TextLink("Buy Credits")],
        ),
      ),
    ],
  );
}
