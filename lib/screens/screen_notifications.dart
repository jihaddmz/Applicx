import 'dart:ffi';

import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/item_notification.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/models/model_notification.dart';
import 'package:flutter/material.dart';

class ScreenNotifications extends StatefulWidget {
  @override
  _ScreenNotifications createState() => _ScreenNotifications();
}

class _ScreenNotifications extends State<ScreenNotifications>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late List<ModelNotification> _list;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 1.0, end: 0.0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  @override
  void initState() {
    super.initState();

    fetchRecentNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeTransition(
        opacity: _fadeAnimation,
        child: Button("Clear All", () {
          if (_index == 0) {
          } else {
            // don't do anything
          }
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/images/image_back.png"),
        ),
      ),
      body: SafeArea(
          child: Stack(
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
                TextGrey("You have ${_list.length} new notifications"),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: CardToggler(
                      textLeft: "Recent",
                      textRight: "Cleared",
                      onToggle: (index) {
                        setState(() {
                          _index = index;
                        });
                        if (index == 0) {
                          fetchRecentNotifications();
                          _controller.reverse();
                        } else {
                          fetchClearedNotifications();
                          _controller.forward();
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: listOfNotifications(),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  List<Widget> listOfNotifications() {
    List<Widget> list = [];
    for (var element in _list) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemNotification(context, element,
            _index == 0 ? Color(0xffFF6F77) : Color(0xff243141)),
      ));
    }

    return list;
  }

  void fetchRecentNotifications() {
    _list = [
      ModelNotification(
          id: 0, message: "Subscription is now at 5\$", date: "Just Now"),
      ModelNotification(
          id: 1, message: "Subscription is now at 5\$", date: "5 Hours"),
      ModelNotification(
          id: 2, message: "100\$ Successfully deposit", date: "Yesterday")
    ];
  }

  void fetchClearedNotifications() {
    _list = [
      ModelNotification(
          id: 0, message: "Subscription is now at 5\$", date: "Just Now"),
      ModelNotification(
          id: 1,
          message: "App is disabled, pay to re-enable",
          date: "10 Hours"),
      ModelNotification(
          id: 2, message: "100\$ Successfully deposit", date: "Yesterday")
    ];
  }
}
