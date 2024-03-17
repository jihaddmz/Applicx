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
      body: SafeArea(
          child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  child: Image.asset(
                    "assets/images/image_chatbot_settings.png",
                    width: 120,
                    height: 300,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            padding: const EdgeInsets.only(top: 50),
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
                                    onTap: () async {
                                      if (await HelperUtils.isConnected()) {
                                        Navigator.of(context).push(
                                            MyCustomRoute(
                                                (BuildContext context) {
                                          return ScreenSettingsDeposit(
                                            walletAmount: _walletAmount,
                                          );
                                        },
                                                RouteSettings(),
                                                ScreenSettingsDeposit(
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
                                    onTap: () async {
                                      HelperUtils.goToWhatsapp();
                                    },
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
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              elevation: 0,
                                              title: TextBoldBlack(
                                                  "Privacy & Terms",
                                                  textAlign: TextAlign.center),
                                              content: SingleChildScrollView(
                                                child: TextNormalBlack(
                                                    """ **Privacy Policy for Applicx**

Effective Date: [Insert Date]

Thank you for using Applicx! This Privacy Policy explains how we collect, use, and safeguard your personal information when you use our mobile application and services provided by Appsfourlife.

**1. Information We Collect:**

We only collect user activities such as payments and transactions made within the Applicx platform. We do not collect any personal data from users.

**2. Use of Collected Information:**

The data collected, which includes user activities, is stored securely in our database solely for the purpose of providing transaction history and related services within the Applicx platform.

**3. Data Security:**

We take appropriate measures to safeguard the data collected from unauthorized access, alteration, disclosure, or destruction. All data is stored securely in our database and is not accessed on the cloud.

**4. Wallet Transactions:**

Users can add funds to their wallet within the Applicx platform using supported cash transfer services. The added funds are non-refundable and can only be used within the app for purchasing services offered by Applicx. We only accept USD currency for wallet transactions.

**5. User Accounts:**

To create an account, Applicx team must provide a unique username. The number of devices that can sign in to the account simultaneously is determined during account creation. Users have the option to add funds to their wallet at the time of account creation.

**6. Subscription Fees:**

Applicx offers a monthly subscription service with fees deducted from the user's wallet amount. The subscription is auto-renewed if there are sufficient funds in the wallet. If the user does not have enough funds, they will have a 3-day extension to refill the wallet. Failure to renew the subscription within 3 months will result in account deactivation and deletion of all associated data.

**7. Card Voucher and Credit Availability:**

Please note that card vouchers and credits may become unavailable at any time during the day based on their availability. We apologize for any inconvenience this may cause and appreciate your understanding.

**8. User Responsibility:**

Users are solely responsible for ensuring the accuracy of their transactions, including the purchase of card vouchers and sending credits or gifts to the correct phone numbers. Applicx is not responsible for any errors or discrepancies resulting from user actions.

**9. 24/7 Support:**

We are available 24/7 to assist you with any questions or concerns you may have. Please feel free to reach out to us at any time.

**10. Wallet Funding Time:**

Please be aware that it may take 1 to 3 hours to add money to your wallet after receiving the funds from the cash transfer providers.

**11. Contact Information:**

For any inquiries or concerns regarding this Privacy Policy or our practices, please contact Nomair Raya at +76 554 635 or Jihad Mahfouz at +81 909 560.

**12. Applicx Availability:**

Our mobile application, Applicx, is available for download on both the App Store and Google Play Store.

**13. No Password Requirement:**

Applicx does not require a password for access. Users only need their unique username to sign in.

**14. Limitation on Account Sign-ins:**

Each user account is allowed only one simultaneous sign-in. The number of allowed sign-ins depends on the number of users signing in to the same account within a store.

**15. Changes to this Privacy Policy:**

We reserve the right to modify this Privacy Policy at any time. Changes and clarifications will take effect immediately upon their posting on the Applicx platform. Users are encouraged to review this Privacy Policy periodically for any updates.

By using the Applicx platform, you consent to the terms of this Privacy Policy.

---

**Terms of Service for Applicx**

These Terms of Service ("Terms") govern your access to and use of the Applicx mobile application and services provided by Appsfourlife ("Provider"). By accessing or using the Applicx platform, you agree to be bound by these Terms.

**1. Services Provided:**

Provider offers the Applicx platform, which enables users to facilitate various transactions, including topping up carrier credits, sending gifts, purchasing vouchers, and tracking payment transactions.

**2. User Obligations:**

Users are required to create an account with a unique username provided by Provider. Users must adhere to all usage guidelines and are responsible for maintaining the security of their account. Users agree to comply with all applicable laws and regulations when using the Applicx platform.

**3. Payment Terms:**

Users may add funds to their wallet within the Applicx platform using supported cash transfer services. Wallet funds are non-refundable and can only be used for purchasing services offered by Applicx. Subscription fees are deducted automatically from the user's wallet amount on a monthly basis.

**4. Intellectual Property:**

All intellectual property rights related to the Applicx platform, including but not limited to trademarks, copyrights, and patents, are owned by Appsfourlife. Users are granted a limited, non-exclusive, non-transferable license to use the platform for its intended purposes.

**5. Privacy Policy:**

User data is collected, used, and protected in accordance with the Privacy Policy outlined by Provider. By using the Applicx platform, users consent to the terms of the Privacy Policy.

**6. Limitation of Liability:**

Appsfourlife shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of the Applicx platform. In no event shall Appsfourlife's total liability exceed the amount paid by the user for the use of the platform.

**7. Indemnification:**

Users agree to indemnify and hold harmless Appsfourlife from any liabilities, claims, damages, or expenses arising out of or in any way related to their use of the Applicx platform or violation of these Terms.

**8. Termination:**

Appsfourlife reserves the right to terminate or suspend access to the Applicx platform at any time for any reason. Users may terminate their account by contacting Provider.
 """,
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              actions: [
                                                ButtonSmall("OK", () {
                                                  Navigator.pop(context);
                                                })
                                              ],
                                            );
                                          });
                                    },
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
      )),
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
                  await HelperFirebaseFirestore.createPaymentEntry(
                      _subscriptionFees.toString(),
                      DateTime.now().toString().split("\\.")[0],
                      "Subscription Fees");
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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Center(
                  child: SvgPicture.asset(
                    imagePath,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextNormalBlack(textTop),
                    Visibility(
                        visible: textBottom != null,
                        child: TextGrey(textBottom ?? ""))
                  ],
                ),
              )
            ],
          ),
          action
        ],
      ),
    );
  }
}
