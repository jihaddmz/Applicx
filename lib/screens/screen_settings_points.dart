// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_cart_recharge_voucher.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/fab_scrolltotop.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ScreenSettingsPoints extends StatefulWidget {
  ScreenSettingsPoints({required this.pointsAmount});

  final double pointsAmount;

  @override
  _ScreenSettingsPoints createState() => _ScreenSettingsPoints();
}

class _ScreenSettingsPoints extends State<ScreenSettingsPoints> {
  final ScrollController scrollController = ScrollController();
  WidgetsToImageController controller = WidgetsToImageController();

  List<ModelCartVoucher> _listOfAlfaCardVouchers = [];
  List<ModelCartVoucher> _listOfTouchCardVouchers = [];
  List<ModelCartVoucher> _list = [];
  late BuildContext mContext;
  int _tabIndex = 0;
  double _pointsAmount = 0;

  @override
  void initState() {
    super.initState();

    _pointsAmount = widget.pointsAmount;

    Future.delayed(const Duration(milliseconds: 200), () {
      fetchRewardCardVouchers();
    });

    fetchPoints();
  }

  Future<void> fetchPoints() async {
    HelperFirebaseFirestore.fetchUserPoints((p0) {
      setState(() {
        _pointsAmount = double.parse(p0["points"]);
      });
    });
  }

  void setListChosen() {
    setState(() {
      _list =
          _tabIndex == 0 ? _listOfAlfaCardVouchers : _listOfTouchCardVouchers;
    });
  }

  Future<void> fetchRewardCardVouchers() async {
    HelperDialog.showLoadingDialog(mContext, "Fetching Rewards Cards...");
    await HelperFirebaseFirestore.fetchRewardsCardVouchers((event) {
      _listOfAlfaCardVouchers.clear();
      for (var element in event.docs) {
        double credits = double.parse(element.id.toString().split("_")[2]);
        int daysAvailability = int.parse(element.id.split("_")[1]);
        String imagePath = credits == 1.22
            ? "assets/images/image_cart_1.png"
            : credits == 3.03
                ? "assets/images/image_cart_2.png"
                : credits == 4.50
                    ? "assets/images/image_cart_3.png"
                    : credits == 7.58
                        ? "assets/images/image_cart_4.png"
                        : credits == 13.5
                            ? "assets/images/image_cart_2.png"
                            : credits == 7.5
                                ? "assets/images/image_cart_4.png"
                                : "assets/images/image_cart_5.png";
        Color color = credits == 1.22
            ? Color(0xffFDD848)
            : credits == 3.30
                ? const Color(0xffFFB1B6)
                : credits == 4.50
                    ? Color(0xffBCDBD7)
                    : credits == 7.58
                        ? Color(0xffCDBCDB)
                        : credits == 13.5 || credits == 7.50
                            ? Color(0xffD9D9D9)
                            : Color(0xffAAD59E);
        String instruction = "Dial *14*ActivationCode#";
        Map<String, dynamic> map = element.get("list");

        List<MapEntry<String, dynamic>> list = map.entries.toList()
          ..sort((a, b) => DateTime.parse(a.value.toString())
              .compareTo(DateTime.parse(b.value.toString())));

        Map<String, dynamic> sortedMap = Map.fromEntries(list);

        // if the card is not waffer
        _listOfAlfaCardVouchers.add(ModelCartVoucher(
            id: element.id,
            isAlfa: true,
            title: "",
            cost: double.parse(element.get("cost")),
            daysAvailability: daysAvailability,
            availability: map.length,
            dolars: credits,
            imagePath: imagePath,
            color: color,
            map: sortedMap,
            instruction: instruction));
      }

      setListChosen();
    }, true);

    await HelperFirebaseFirestore.fetchRewardsCardVouchers((event) {
      _listOfTouchCardVouchers.clear();
      for (var element in event.docs) {
        double credits = double.parse(element.id.toString().split("_")[2]);
        int daysAvailability = int.parse(element.id.split("_")[1]);
        String imagePath = credits == 1.22
            ? "assets/images/image_cart_1.png"
            : credits == 1.0
                ? "assets/images/image_cart_2.png"
                : credits == 1.67
                    ? "assets/images/image_cart_3.png"
                    : credits == 3.79
                        ? "assets/images/image_cart_4.png"
                        : credits == 4.5
                            ? "assets/images/image_cart_5.png"
                            : credits == 7.5
                                ? "assets/images/image_cart_4.png"
                                : "assets/images/image_cart_5.png";
        Color color = credits == 1.0
            ? Color(0xffFDD848)
            : credits == 1.67
                ? const Color(0xffFFB1B6)
                : credits == 3.79
                    ? Color(0xffBCDBD7)
                    : credits == 4.5
                        ? Color(0xffCDBCDB)
                        : credits == 13.5 || credits == 7.50
                            ? Color(0xffD9D9D9)
                            : Color(0xffAAD59E);
        String instruction = "Dial *200*ActivationCode#";
        Map<String, dynamic> map = element.get("list");

        List<MapEntry<String, dynamic>> list = map.entries.toList()
          ..sort((a, b) => DateTime.parse(a.value.toString())
              .compareTo(DateTime.parse(b.value.toString())));

        Map<String, dynamic> sortedMap = Map.fromEntries(list);

        // if the card is not waffer
        _listOfTouchCardVouchers.add(ModelCartVoucher(
            id: element.id,
            isAlfa: false,
            title: "",
            cost: double.parse(element.get("cost")),
            daysAvailability: daysAvailability,
            availability: map.length,
            dolars: credits,
            imagePath: imagePath,
            color: color,
            map: sortedMap,
            instruction: instruction));
      }

      setListChosen();
    }, false);

    Navigator.pop(mContext);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return Scaffold(
      floatingActionButton: FABScrollTopTop(scrollController: scrollController),
      body: SafeArea(
          child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/images/image_back.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        "assets/images/image_points_box.png",
                        width: 100,
                        height: 100,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextBoldBlack("Redeem Gifts"),
                      ),
                      TextGrey(
                          "Check gifts available and \nredeem using your points."),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: CardToggler(
                              textLeft: "Alfa",
                              iconLeft: Image.asset(
                                  "assets/images/logo_alfa.png",
                                  width: 20,
                                  height: 20),
                              textRight: "Touch",
                              iconRight: Image.asset(
                                  "assets/images/logo_touch.png",
                                  width: 20,
                                  height: 20),
                              onToggle: (index) {
                                setState(() {
                                  _tabIndex = index;
                                });
                                setListChosen();
                              }),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Divider(
                                color: Colors.black,
                                thickness: 3,
                                indent: 70,
                                endIndent: 70,
                              ),
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: TextField(
                                  controller: TextEditingController(
                                      text: "$_pointsAmount"),
                                  enabled: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      floatingLabelAlignment:
                                          FloatingLabelAlignment.center,
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                              color: Color(_tabIndex == 0
                                                  ? 0xffFF6F77
                                                  : 0xff009CBC),
                                              width: 5)),
                                      labelText: "Points",
                                      labelStyle: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: widgetsOfPayments(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  List<Widget> widgetsOfPayments() {
    List<Widget> result = [];

    for (var element in _list) {
      result.add(Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CardCartRechargeVoucher(
              modelCartVoucher: element,
              isPoints: true,
              onActionPerformed: (modelCartVoucher, action) async {
                if (_pointsAmount < modelCartVoucher.cost) {
                  HelperDialog.showDialogInfo(
                      "Warning!",
                      "There is no enough points to complete the transaction.",
                      context,
                      () {});
                  return;
                }

                if (!await HelperUtils.isConnected()) {
                  HelperDialog.showDialogNotConnectedToInternet(context);
                  return;
                }

                showDialog(
                    barrierDismissible: false,
                    context: mContext,
                    builder: (context) {
                      return AlertDialog(
                          backgroundColor: const Color(0xffF2F2F2),
                          elevation: 0,
                          contentPadding: const EdgeInsets.all(10),
                          title: Center(
                            child: TextBoldBlack("Attention!"),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextGrey(
                                  "Are you sure you want to purchase this cart?",
                                  textAlign: TextAlign.center),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextNormalBlack("Cart:"),
                                      ),
                                      TextGrey(
                                          "Alfa ${modelCartVoucher.title == "وفّر" ? "Waffer" : ""} ${modelCartVoucher.dolars}\$"),
                                      Image.asset(
                                        modelCartVoucher.isAlfa
                                            ? "assets/images/logo_alfa.png"
                                            : "assets/images/logo_touch.png",
                                        width: 50,
                                        height: 50,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonSmall("No", () {
                                      setState(() {
                                        modelCartVoucher.isCardClicked = false;
                                      });
                                      Navigator.pop(mContext);
                                    }, color: const Color(0xffFF6F77)),
                                    ButtonSmall("Pay ${modelCartVoucher.cost}P",
                                        () async {
                                      Navigator.pop(mContext);
                                      HelperDialog.showLoadingDialog(mContext,
                                          "Processing Transaction...");
                                      setState(() {
                                        modelCartVoucher.isCardClicked = false;
                                        _pointsAmount -= modelCartVoucher.cost;
                                      });
                                      await HelperSharedPreferences.setPoints(
                                          _pointsAmount.toString());

                                      await HelperUtils.minusPoints(
                                          modelCartVoucher.cost);

                                      setState(() {
                                        modelCartVoucher.isCardClicked = false;
                                      });

                                      var modelCardVoucher1 =
                                          await HelperFirebaseFirestore
                                              .removeRewardingCardVoucher(
                                                  modelCartVoucher);

                                      await HelperFirebaseFirestore
                                          .createCardVoucherHistory(
                                              modelCardVoucher1,
                                              await HelperSharedPreferences
                                                  .getUsername(),
                                              await HelperSharedPreferences
                                                  .getPhoneNumber());

                                      await HelperUtils.minusPoints(
                                          modelCardVoucher1.cost);

                                      Navigator.pop(mContext);

                                      showDialog(
                                          barrierDismissible: false,
                                          context: mContext,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              elevation: 0,
                                              backgroundColor:
                                                  const Color(0xffF2F2F2),
                                              title: Align(
                                                alignment: Alignment.center,
                                                child:
                                                    TextBoldBlack("Share Info"),
                                              ),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: TextGrey(
                                                        "You will share the purchased cart as an image"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: WidgetsToImage(
                                                        controller: controller,
                                                        child: Card(
                                                          elevation: 0,
                                                          color: const Color(
                                                              0xffffffff),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child: Image
                                                                          .asset(
                                                                        !modelCardVoucher1.isAlfa
                                                                            ? "assets/images/logo_touch.png"
                                                                            : "assets/images/logo_alfa.png",
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextNormalBlack(
                                                                            "Activation Code"),
                                                                        TextGrey(modelCardVoucher1
                                                                            .map
                                                                            .keys
                                                                            .elementAt(0)),
                                                                        TextNormalBlack(
                                                                            "Expiration Date"),
                                                                        TextGrey(modelCardVoucher1
                                                                            .map
                                                                            .values
                                                                            .elementAt(0)
                                                                            .toString()),
                                                                        TextNormalBlack(
                                                                            "Instruction"),
                                                                        TextGrey(
                                                                            "Dial *${modelCardVoucher1.isAlfa ? "14" : "200"}*${modelCardVoucher1.map.keys.elementAt(0)}#"),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                TextNormalBlack("${modelCardVoucher1.dolars}\$", textAlign: TextAlign.right),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                              actions: [
                                                ButtonSmall("Save", () {
                                                  Navigator.pop(mContext);
                                                },
                                                    color: const Color(
                                                        0xff9ECCFA)),
                                                ButtonSmall("Share", () {
                                                  final bytes =
                                                      controller.capture();
                                                  bytes.then((bytes) async {
                                                    if (bytes != null) {
                                                      getApplicationDocumentsDirectory()
                                                          .then((value) async {
                                                        File file = File(
                                                            "${value.path}/image.png");
                                                        file.writeAsBytes(
                                                            bytes);

                                                        await Share.shareFiles(
                                                            [file.path]);

                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                  });
                                                },
                                                    color:
                                                        const Color(0xffAAD59E))
                                              ],
                                              actionsAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                            );
                                          });
                                    }, color: const Color(0xffAAD59E))
                                  ],
                                ),
                              )
                            ],
                          ));
                    });
              })));
    }

    return result;
  }
}
