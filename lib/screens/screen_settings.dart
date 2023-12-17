import 'package:applicx/components/button.dart';
import 'package:applicx/components/drop_down.dart';
import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenSettings extends StatefulWidget {
  @override
  _ScreenSettings createState() => _ScreenSettings();
}

class _ScreenSettings extends State<ScreenSettings> {
  bool _isSubscriptionActive = true;
  String _user = "User123";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
                right: 0,
                child: Image.asset("assets/images/image_chatbot_settings.png")),
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
                          ItemSettingHeadline("Wallet:", "133.00\$"),
                          ItemSettingHeadline("Subscription Fees:", "20\$"),
                          ItemSettingHeadline("Expiration Date:", "12/12/23"),
                          ItemSettingHeadline("Last Payment Date:", "12/12/23"),
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
                          child: Card(
                            color: const Color(0xffF7F7F7),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ItemSettingAction(
                                  _user,
                                  "Edit Account Details",
                                  "assets/svgs/vector_profile.svg",
                                  const Color(0xffFFB1B6),
                                  GestureDetector(
                                    onTap: () {},
                                    child: SvgPicture.asset(
                                        "assets/svgs/vector_arrow_next.svg"),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TextNormalBlack("General"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Card(
                            color: const Color(0xffF7F7F7),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Dark Mode",
                                      null,
                                      "assets/svgs/vector_moon.svg",
                                      const Color(0xff243141),
                                      GestureDetector(
                                        onTap: () {},
                                        child: SvgPicture.asset(
                                            "assets/svgs/vector_toggle_off.svg"),
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ItemSettingAction(
                                      "Language",
                                      null,
                                      "assets/svgs/vector_language.svg",
                                      const Color(0xff9ECCFA),
                                      MyDropDown(
                                        list: const ["en", "fr"],
                                        label: "",
                                        onSelect: (item) {},
                                        initialSelected: "en",
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Subscription",
                                      null,
                                      "assets/svgs/vector_tap.svg",
                                      const Color(0xffFDD848),
                                      GestureDetector(
                                        onTap: () {},
                                        child: ButtonSmall("Renew", () {},
                                            color: const Color(0xffF2F2F2)),
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Wallet Deposits",
                                      null,
                                      "assets/svgs/vector_deposit.svg",
                                      const Color(0xffAAD59E),
                                      GestureDetector(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg"))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Wallet Payments",
                                      null,
                                      "assets/svgs/vector_money.svg",
                                      const Color(0xffCDBCDB),
                                      GestureDetector(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg"))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: TextNormalBlack("Support"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Card(
                            color: const Color(0xffF7F7F7),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Contact Us",
                                      null,
                                      "assets/svgs/vector_support.svg",
                                      const Color(0xff243141),
                                      GestureDetector(
                                        onTap: () {},
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: SvgPicture.asset(
                                                "assets/svgs/vector_arrow_next.svg")),
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ItemSettingAction(
                                      "Privacy & Terms",
                                      null,
                                      "assets/svgs/vector_privacy.svg",
                                      const Color(0xff243141),
                                      GestureDetector(
                                          onTap: () {},
                                          child: SvgPicture.asset(
                                              "assets/svgs/vector_arrow_next.svg"))),
                                ),
                              ],
                            ),
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
    );
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
