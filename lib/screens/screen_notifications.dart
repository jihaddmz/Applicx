import 'package:applicx/colors.dart';
import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/fab_scrolltotop.dart';
import 'package:applicx/components/item_notification.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/models/model_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenNotifications extends StatefulWidget {
  ScreenNotifications();

  @override
  _ScreenNotifications createState() => _ScreenNotifications();
}

class _ScreenNotifications extends State<ScreenNotifications>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  List<ModelNotification> _list = [];
  List<ModelNotification> initiaList = [];
  final ScrollController scrollController = ScrollController();

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

    Future.delayed(const Duration(milliseconds: 200), () {
      fetchAllNotifications().then((value) {
        Navigator.of(context).pop();

        getNewNotifications();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FABScrollTopTop(scrollController: scrollController),
      appBar: null,
      body: SafeArea(
          child: SingleChildScrollView(
        controller: scrollController,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context,
                        _list.where((element) => !element.cleared).toList());
                  },
                  child: Image.asset(
                    "assets/images/image_back.png",
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                "assets/images/image_chatbot_notifications.png",
                width: 130,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBoldBlack("Notifications"),
                  TextGrey(
                      "You have ${_index == 0 ? _list.length : 0} new notifications"),
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
                            getNewNotifications();
                            _controller.reverse();
                          } else {
                            getClearedNotifications();
                            _controller.forward();
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _list.isNotEmpty && _index == 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (_index == 0) {
                            if (_list.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      title: TextLessBoldBlack("Attention!",
                                          textAlign: TextAlign.center),
                                      content: TextGrey(
                                          "Are you sure want to clear all new notifications?",
                                          textAlign: TextAlign.center),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        ButtonSmall("No", () {
                                          Navigator.pop(context);
                                        }),
                                        ButtonSmall("Yes", color: colorGreen,
                                            () async {
                                          Navigator.pop(context);
                                          await clearAllNewNotifications();
                                        }),
                                      ],
                                    );
                                  });
                            }
                          } else {
                            // don't do anything
                          }
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child:
                              SvgPicture.asset("assets/svgs/vector_delete.svg"),
                        ),
                      )),
                  Visibility(
                    visible: _list.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: listOfNotifications(),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _list.isEmpty,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextNormalBlack("No Notifications Found"),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 30, 0, 0),
                                child: Image.asset(
                                  "assets/images/image_chatbot_noresults.png",
                                  height: 250,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  List<Widget> listOfNotifications() {
    List<Widget> list = [];
    for (var element in _list) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemNotification(context, element,
            _index == 0 ? const Color(0xffFF6F77) : const Color(0xff243141)),
      ));
    }

    return list;
  }

  Future<void> fetchAllNotifications() async {
    HelperDialog.showLoadingDialog(context, "Fetching...");
    Map<String, dynamic> map =
        await HelperFirebaseFirestore.fetchNotifications();

    map.forEach((key, value) {
      initiaList.add(ModelNotification(
          message: value["msg"], date: key, cleared: value["cleared"]));
    });

    setState(() {
      _list = initiaList;
    });
  }

  Future<void> getNewNotifications() async {
    setState(() {
      _list = initiaList.where((element) => !element.cleared).toList();
    });

    _list.sort((a, b) {
      // sorting the list from the newest to the oldest
      DateTime dateTime1 = DateTime.parse(a.date);
      DateTime dateTime2 = DateTime.parse(b.date);
      return dateTime2.compareTo(dateTime1);
    });
  }

  Future<void> getClearedNotifications() async {
    setState(() {
      _list = initiaList.where((element) => element.cleared).toList();
    });

    _list.sort((a, b) {
      // sorting the list from the newest to the oldest
      DateTime dateTime1 = DateTime.parse(a.date);
      DateTime dateTime2 = DateTime.parse(b.date);
      return dateTime2.compareTo(dateTime1);
    });
  }

  Future<void> clearAllNewNotifications() async {
    HelperDialog.showLoadingDialog(context, "Clearing Notifications...");
    Map<String, dynamic> map = {};
    for (var element in _list) {
      map[element.date] = {"cleared": true, "msg": element.message};
    }

    setState(() {
      _list.clear();
    });

    for (var element in initiaList) {
      if (!element.cleared) element.cleared = true;
    }

    await HelperFirebaseFirestore.setNotificationsAsCleared(map);

    Navigator.pop(context);
  }
}
