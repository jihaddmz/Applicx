// ignore_for_file: use_build_context_synchronously

import 'package:applicx/components/button.dart';
import 'package:applicx/components/custom_route.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/screens/screen_intros.dart';
import 'package:applicx/screens/screen_settings_deposit.dart';
import 'package:applicx/screens/screen_settings_editprofile.dart';
import 'package:applicx/screens/screen_settings_payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';

class ScreenSettings extends StatefulWidget {
  ScreenSettings({required this.walletAmount, this.toRenew = false});

  final double walletAmount;
  final bool toRenew;

  @override
  _ScreenSettings createState() => _ScreenSettings();
}

class _ScreenSettings extends State<ScreenSettings> {
  bool _isSubscriptionActive = true;
  String _user = "";
  String _darkModeIconPath = "assets/svgs/vector_toggle_off.svg";
  double _walletAmount = 0;
  String _expDate = "";
  double _subscriptionFees = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _isSubscriptionActive = !widget.toRenew;

    HelperSharedPreferences.getExpDate().then((value) {
      setState(() {
        _expDate = value;
      });
    });

    HelperSharedPreferences.getSubscriptionFees().then((value) {
      setState(() {
        _subscriptionFees = value;
      });
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (widget.toRenew) {
        renewSubscription();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetching username from sharedpreferences
    HelperSharedPreferences.getUsername().then((value) {
      setState(() {
        _user = value;
      });
    });

    // setting walltAmount
    setState(() {
      _walletAmount = widget.walletAmount;
    });

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  child:
                      Image.asset("assets/images/image_chatbot_settings.png")),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBoldBlack("Settings"),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SvgPicture.asset(
                                          "assets/svgs/vector_circle_black.svg"),
                                    ),
                                    TextGrey(" App Status:")
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SvgPicture.asset(
                                        "assets/svgs/vector_circle_black.svg",
                                        color: Color(_isSubscriptionActive
                                            ? 0xffA0F987
                                            : 0xffE11F2B),
                                      ),
                                    ),
                                    TextGrey(
                                      _isSubscriptionActive
                                          ? " Active"
                                          : " Not Active",
                                    )
                                  ],
                                )
                              ],
                            ),
                            ItemSettingHeadline("Wallet:",
                                "${_walletAmount.toStringAsFixed(2)}\$"),
                            ItemSettingHeadline(
                                "Subscription Fees:", "${_subscriptionFees}\$"),
                            ItemSettingHeadline(
                                "Expiration Date:", _expDate.split(" ")[0]),
                            ItemSettingHeadline("App Version:", "1.0"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextNormalBlack("Profile"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MyCustomRoute(
                                    (BuildContext context) {
                                  return ScreenSettingsEditProfile(
                                      username: _user);
                                },
                                    const RouteSettings(),
                                    ScreenSettingsEditProfile(
                                        username: _user)));
                              },
                              child: Card(
                                color: const Color(0xffF7F7F7),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      _user,
                                      "Account Details",
                                      "assets/svgs/vector_profile.svg",
                                      const Color(0xffFFB1B6),
                                      SvgPicture.asset(
                                          "assets/svgs/vector_arrow_next.svg")),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 20),
                          //   child: TextNormalBlack("General"),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 5),
                          //   child: Card(
                          //     color: const Color(0xffF7F7F7),
                          //     child: Column(
                          //       children: [
                          //         Padding(
                          //           padding:
                          //               const EdgeInsets.symmetric(vertical: 10),
                          //           child: ItemSettingAction(
                          //               "Dark Mode",
                          //               null,
                          //               "assets/svgs/vector_moon.svg",
                          //               const Color(0xff243141),
                          //               GestureDetector(
                          //                 onTap: () {
                          //                   setState(() {
                          //                     if (_darkModeIconPath ==
                          //                         "assets/svgs/vector_toggle_off.svg") {
                          //                       _darkModeIconPath =
                          //                           "assets/svgs/vector_toggle_on.svg";
                          //                     } else {
                          //                       _darkModeIconPath =
                          //                           "assets/svgs/vector_toggle_off.svg";
                          //                     }
                          //                   });
                          //                 },
                          //                 child:
                          //                     SvgPicture.asset(_darkModeIconPath),
                          //               )),
                          //         ),
                          //         Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 vertical: 10),
                          //             child: ItemSettingAction(
                          //               "Language",
                          //               null,
                          //               "assets/svgs/vector_language.svg",
                          //               const Color(0xff9ECCFA),
                          //               MyDropDown(
                          //                 list: const ["en", "fr"],
                          //                 label: "",
                          //                 onSelect: (item) {},
                          //                 initialSelected: "en",
                          //               ),
                          //             ))
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextNormalBlack("Account"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Card(
                              color: const Color(0xffF7F7F7),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ItemSettingAction(
                                        "Subscription",
                                        null,
                                        "assets/svgs/vector_tap.svg",
                                        const Color(0xffFDD848),
                                        ButtonSmall("Renew", () async {
                                          renewSubscription();
                                        }, color: const Color(0xffF2F2F2))),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MyCustomRoute(
                                          (BuildContext context) {
                                        return ScreenSettingsDeposit();
                                      }, RouteSettings(),
                                          ScreenSettingsDeposit()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ItemSettingAction(
                                          "Wallet Deposits",
                                          null,
                                          "assets/svgs/vector_deposit.svg",
                                          const Color(0xffAAD59E),
                                          SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg")),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await HelperUtils.isConnected()) {
                                        Navigator.of(context).push(
                                            MyCustomRoute(
                                                (BuildContext context) {
                                          return ScreenSettingsPayments(
                                            walletAmount: _walletAmount,
                                          );
                                        },
                                                const RouteSettings(),
                                                ScreenSettingsPayments(
                                                  walletAmount: _walletAmount,
                                                )));
                                      } else {
                                        HelperDialog
                                            .showDialogNotConnectedToInternet(
                                                context);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ItemSettingAction(
                                          "Wallet Payments",
                                          null,
                                          "assets/svgs/vector_money.svg",
                                          const Color(0xffCDBCDB),
                                          SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextNormalBlack("Support"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Card(
                              color: const Color(0xffF7F7F7),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ItemSettingAction(
                                          "Contact Us",
                                          null,
                                          "assets/svgs/vector_support.svg",
                                          const Color(0xff243141),
                                          SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg")),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ItemSettingAction(
                                          "Privacy & Terms",
                                          null,
                                          "assets/svgs/vector_privacy.svg",
                                          const Color(0xff243141),
                                          SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Button("Log Out", () async {
                                if (!await HelperUtils.isConnected()) {
                                  HelperDialog.showDialogNotConnectedToInternet(
                                      context);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          elevation: 0,
                                          title: TextBoldBlack("Attention",
                                              textAlign: TextAlign.center),
                                          content: TextGrey(
                                              "Are you sure you want to log out?"),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            ButtonSmall("No", () {
                                              Navigator.pop(context);
                                            }),
                                            ButtonSmall("Yes", () async {
                                              Navigator.pop(
                                                  _scaffoldKey.currentContext!);
                                              HelperDialog.showLoadingDialog(
                                                  context, "Signing Out...");
                                              if (!widget.toRenew) {
                                                await HelperFirebaseFirestore
                                                    .updateNumberOfDevicesSignedIn(
                                                        await HelperSharedPreferences
                                                            .getUsername(),
                                                        await HelperSharedPreferences
                                                                .getNbreOfDevicesSignedIn() +
                                                            1);
                                                await HelperSharedPreferences
                                                    .clearSharedPreferences();
                                                Navigator.of(_scaffoldKey
                                                        .currentContext!)
                                                    .pop();
                                                Navigator.of(_scaffoldKey
                                                        .currentContext!)
                                                    .pushAndRemoveUntil(
                                                        MyCustomRoute(
                                                            (context) =>
                                                                ScreenIntros(),
                                                            const RouteSettings(),
                                                            ScreenIntros()),
                                                        (route) => false);
                                              }
                                            }, color: const Color(0xffAAD59E)),
                                          ],
                                        );
                                      });
                                }
                              }, color: const Color(0xffFFB1B6)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> renewSubscription() async {
    if (_walletAmount >= _subscriptionFees) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
              content: TextGrey(
                  "Are you sure you want to renew your subscription for $_subscriptionFees\$?",
                  textAlign: TextAlign.center),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ButtonSmall("No", () {
                  Navigator.pop(context);

                  if (widget.toRenew) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            title: TextBoldBlack("Attention!",
                                textAlign: TextAlign.center),
                            content: TextGrey(
                                "Please renew your subscription to continue using the app.",
                                textAlign: TextAlign.center),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              ButtonSmall("OK", () async {
                                Navigator.pop(context);
                                renewSubscription();
                              })
                            ],
                          );
                        });
                  }
                }),
                ButtonSmall("Yes", () async {
                  Navigator.pop(_scaffoldKey.currentContext!);
                  HelperDialog.showLoadingDialog(
                      context, "Renewing Subscription...");
                  if (!await HelperUtils.isConnected()) {
                    Navigator.pop(context);
                    HelperDialog.showDialogNotConnectedToInternet(context);
                    return;
                  }
                  double newWallet = _walletAmount - _subscriptionFees;
                  String newExpDate = DateTime.parse(_expDate)
                      .add(const Duration(days: 33))
                      .toString();
                  setState(() {
                    _walletAmount = newWallet;
                    _expDate = newExpDate;
                    _isSubscriptionActive = true;
                  });
                  await HelperFirebaseFirestore.setExpDate(newExpDate);
                  await HelperSharedPreferences.setExpDate(newExpDate);
                  await HelperFirebaseFirestore.setWalletAmount(newWallet);
                  await HelperSharedPreferences.setWalletAmount(newWallet);
                  Navigator.of(_scaffoldKey.currentContext!).pop();

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 0,
                          title: TextBoldBlack("Successfully Renewed!!",
                              textAlign: TextAlign.center),
                          content: TextGrey(
                              "You have successfully renewed your subscription. The app will auto restart.",
                              textAlign: TextAlign.center),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ButtonSmall("Done", () {
                              Navigator.pop(context);
                              Phoenix.rebirth(context);
                            })
                          ],
                        );
                      });
                }, color: const Color(0xffAAD59E))
              ],
            );
          });

      // if (widget.toRenew) {
      //   // if the user has come to here to renew their subscription
      //   // when a dialog appeared in the screen main. So the user will be redirected to the
      //   // screen main, and passing an argument of true to tell the system user has renewed
      //   Navigator.pop(context, true);
      // }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
              content: TextGrey(
                  "You don't have enough money in your wallet! Please charge your wallet.",
                  textAlign: TextAlign.center),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ButtonSmall("OK", () {
                  Navigator.pop(context);
                })
              ],
            );
          });
    }
  }

  Widget ItemSettingHeadline(String label, String value) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SvgPicture.asset("assets/svgs/vector_circle_black.svg"),
              ),
              TextGrey(" ${label}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [TextGrey(" ${value}", textAlign: TextAlign.start)],
          )
        ]);
  }

  Widget ItemSettingAction(String textTop, String? textBottom, String imagePath,
      Color color, Widget action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Center(
              child: SvgPicture.asset(
                imagePath,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextNormalBlack(textTop),
              Visibility(
                  visible: textBottom != null,
                  child: TextGrey(textBottom ?? ""))
            ],
          ),
          action
        ],
      ),
    );
  }
}
