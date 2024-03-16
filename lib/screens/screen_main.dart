// ignore_for_file: use_build_context_synchronously

import 'package:applicx/colors.dart';
import 'package:applicx/components/button.dart';
import 'package:applicx/components/custom_route.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/models/model_notification.dart';
import 'package:applicx/screens/screen_home.dart';
import 'package:applicx/screens/screen_notifications.dart';
import 'package:applicx/screens/screen_reports.dart';
import 'package:applicx/screens/screen_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMain createState() => _ScreenMain();
}

class _ScreenMain extends State<ScreenMain> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  double _walletAmount = 0;
  String _iconHome = "assets/svgs/vector_home_black.svg";
  String _iconReports = "assets/svgs/vector_reports.svg";
  String _iconSettings = "assets/svgs/vector_settings.svg";
  int _historyReportsNumber = 0;
  bool _isDialogDisabledShown = false;
  bool _toRenew =
      false; // variable indicating if user has to renew his/her subscription
  List<ModelNotification> _listOfNotifications = [];
  bool fetchedNotifications = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late Animation<Offset> _offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
  late final _controllerFade = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await fetchWalletAmount();
      await Future.delayed(const Duration(seconds: 5), () {});
      return true;
    });

    Future.doWhile(() async {
      await fetchUserInformation();
      var isActive = await isUserAccountActive();
      if (isActive) {
        if (!await isAppVersionLatest()) {
          // if the app is not update to the latest latest, tell the user to update

          if (!_isDialogDisabledShown) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 0,
                    title: TextBoldBlack("Attention!",
                        textAlign: TextAlign.center),
                    content: TextGrey(
                        "Please update your app, and relaunch it.",
                        textAlign: TextAlign.center),
                  );
                });
            setState(() {
              _isDialogDisabledShown = true;
            });
          }
        } else {
          // if the app is updated to the latest release, ensure that the expiration date is not crossed
          await isAppExpired();
        }
      }
      await Future.delayed(const Duration(seconds: 10), () {});
      return isActive;
    });

    Future.doWhile(() async {
      await fetchNotifications();
      await Future.delayed(const Duration(seconds: 60), () {});
      return true;
    });
  }

  Future<bool> isUserAccountActive() async {
    var result = true;
    await HelperSharedPreferences.isActive().then((value) {
      if (!value) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 0,
                title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
                content: TextGrey(
                    "Your account has been disabled, please contact Applicx support team.",
                    textAlign: TextAlign.center),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ButtonSmall("Contact US", () async {
                    final Uri url =
                        Uri.parse('https://wa.me/qr/LC33BHI4P7U3O1');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch');
                    }
                  })
                ],
              );
            });
        result = false;
      } else {
        result = true;
      }
    });
    return result;
  }

  Future<void> fetchUserInformation() async {
    await HelperFirebaseFirestore.fetchUserInformation().then((value) async {
      await HelperSharedPreferences.setAddress(value.get("address"));
      await HelperSharedPreferences.setPhoneNumber(value.get("phoneNumber"));
      await HelperSharedPreferences.setIsActive(value.get("isActive"));
      await HelperSharedPreferences.setNbreOfDevicesSignedIn(
          value.get("nbreOfDevicesSignedIn"));
      await HelperSharedPreferences.setSubscriptionFees(
          double.parse(value.get("subscriptionFees")));
    });
  }

  Future<void> fetchWalletAmount() async {
    await HelperFirebaseFirestore.fetchWalletAmount().then((value) async {
      await HelperSharedPreferences.setWalletAmount(value);
    });

    HelperSharedPreferences.getWalletAmount().then((value) {
      setState(() {
        _walletAmount = value;
      });
    });
  }

  Future<void> isAppExpired() async {
    await HelperFirebaseFirestore.fetchExpDate().then((value) async {
      await HelperSharedPreferences.setExpDate(value);
    });

    String expDate = await HelperSharedPreferences.getExpDate();
    DateTime dateTime = DateTime.parse(expDate);
    if (DateTime.now().isAfter(dateTime)) {
      // if the exDate is crossed, tell the user to renew his subscription
      if (!_isDialogDisabledShown) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 0,
                title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
                content: TextGrey(
                    "Please renew your subscription to continue using the app.",
                    textAlign: TextAlign.center),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ButtonSmall("OK", () async {
                    Navigator.pop(context);
                    setState(() {
                      _toRenew = true;
                      _selectedIndex = 2;
                      _iconHome = "assets/svgs/vector_home.svg";
                      _iconSettings = "assets/svgs/vector_settings_black.svg";
                      _offsetAnimation = Tween<Offset>(
                              begin: const Offset(-15, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: _controller, curve: Curves.decelerate));
                    });

                    _controller.reset();
                    _controller.forward();
                  })
                ],
              );
            });

        setState(() {
          _isDialogDisabledShown = true;
        });
      }
    }
  }

  Future<void> fetchNotifications() async {
    Map<String, dynamic> map =
        await HelperFirebaseFirestore.fetchNotifications();
    List<ModelNotification> result = [];
    map.forEach((key, value) {
      if (!value["cleared"]) {
        result.add(ModelNotification(
            message: value["msg"], date: key, cleared: value["cleared"]));
      }
    });

    setState(() {
      _listOfNotifications = result;
    });
  }

  Future<bool> isAppVersionLatest() async {
    String appVersionFromFirebase =
        await HelperFirebaseFirestore.getAppVersion();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return appVersionFromFirebase == packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    HelperSharedPreferences.getWalletAmount().then((value) {
      setState(() {
        _walletAmount = value;
      });
    });

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).viewInsets.bottom == 0 ? 30 : 0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Divider(
              color: colorDarkBlue,
              thickness: 3,
              indent: 70,
              endIndent: 70,
            ),

            /**                                 Wallet Amount          */

            Visibility(
                visible: _selectedIndex == 0,
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: TextEditingController(
                        text: "${_walletAmount.toStringAsFixed(2)} \$"),
                    enabled: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xffF2F2F2), width: 5)),
                        labelText: "Wallet",
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: colorDarkBlue)),
                  ),
                )),

            /**                                 Reports found          */
            Visibility(
                visible: _selectedIndex == 1 &&
                    MediaQuery.of(context).viewInsets.bottom == 0,
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: TextField(
                    controller: TextEditingController(
                        text: "$_historyReportsNumber Record"),
                    enabled: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: Colors.white,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: const BorderSide(
                              color: colorDarkBlue, width: 3)),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconHome,
                  semanticsLabel: "Home",
                ),
                SlideTransition(
                  position: _offsetAnimation,
                  child: Visibility(
                      visible: _selectedIndex == 0,
                      child: SvgPicture.asset(
                        "assets/svgs/vector_circle_black.svg",
                        semanticsLabel: "Home",
                      )),
                )
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconReports,
                  semanticsLabel: "Reports",
                ),
                Visibility(
                    visible: _selectedIndex == 1,
                    child: SlideTransition(
                        key: UniqueKey(),
                        position: _offsetAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SvgPicture.asset(
                            "assets/svgs/vector_circle_black.svg",
                            semanticsLabel: "Reports",
                          ),
                        )))
              ],
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconSettings,
                  semanticsLabel: "Settings",
                ),
                Visibility(
                    visible: _selectedIndex == 2,
                    child: SlideTransition(
                      key: UniqueKey(),
                      position: _offsetAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SvgPicture.asset(
                          "assets/svgs/vector_circle_black.svg",
                          semanticsLabel: "Settings",
                        ),
                      ),
                    ))
              ],
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff243141),
        onTap: (index) {
          if (index == 0) {
            if (_toRenew) {
              return;
            }
            if (_selectedIndex == 1) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 2) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(15, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home_black.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else if (index == 1) {
            if (_toRenew) {
              return;
            }
            if (_selectedIndex == 0) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 2) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports_black.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else {
            if (_selectedIndex == 0) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-15, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 1) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings_black.svg";
          }

          if (_selectedIndex != index) {
            // rerunning the animations of the bottom nav bar circle and pages fade
            _controller.reset();
            _controller.forward();
            _controllerFade.reset();
            _controllerFade.forward();
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 40),
          child: Stack(
            children: [
              Visibility(
                  visible: _selectedIndex == 0,
                  child: FadeTransition(
                      opacity: _controllerFade,
                      child: ScreenHome(
                          walletAmount: _walletAmount,
                          list: _listOfNotifications,
                          onBellIconClick: () async {
                            if (await HelperUtils.isConnected()) {
                              final result = await Navigator.of(context).push(
                                MyCustomRoute((BuildContext context) {
                                  return ScreenNotifications();
                                }, const RouteSettings(),
                                    ScreenNotifications()),
                              ) as List<ModelNotification>;
                              setState(() {
                                _listOfNotifications = result;
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      title: TextBoldBlack("Attention!",
                                          textAlign: TextAlign.center),
                                      content: TextGrey(
                                          "You don't have network access, please connect and try again.",
                                          textAlign: TextAlign.center),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        ButtonSmall("OK", () {
                                          Navigator.pop(context);
                                        })
                                      ],
                                    );
                                  });
                            }
                          }))),
              Visibility(
                  visible: _selectedIndex == 1,
                  child: FadeTransition(
                      opacity: _controllerFade,
                      child: ScreenReports(
                        changeNumberOfReports: (reportsNumber) {
                          setState(() {
                            _historyReportsNumber = reportsNumber;
                          });
                        },
                      ))),
              Visibility(
                  visible: _selectedIndex == 2,
                  child: FadeTransition(
                      opacity: _controllerFade,
                      child: ScreenSettings(
                        walletAmount: _walletAmount,
                        toRenew: _toRenew,
                      ))),
            ],
          )),
    );
  }
}
