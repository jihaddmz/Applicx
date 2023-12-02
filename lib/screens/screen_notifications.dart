import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenNotifications extends StatefulWidget {
  @override
  _ScreenNotifications createState() => _ScreenNotifications();
}

class _ScreenNotifications extends State<ScreenNotifications> {
  Color color1 = Color(243141);
  Color color2 = Color(0xffF5F5F5);
  double elevation1 = 1;
  double elevation2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/image_back.png"),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset("assets/images/image_chatbot_notifications.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBoldBlack("Notifications"),
                TextGrey("You have 3 recent\nnotifications"),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: CardToggler("Recent", "Cleared", color1, color2,
                        elevation1, elevation2, () {
                      setState(() {
                        HelperLogging.logD("entered here");
                        color1 = Color(0xff243141);
                        color2 = Color(0xffF5F5F5);
                        elevation1 = 1;
                        elevation2 = 0;
                      });
                    }, () {
                      setState(() {
                        color1 = Color(0xffF5F5F5);
                        color2 = Color(0xff243141);
                        elevation1 = 0;
                        elevation2 = 1;
                      });
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
