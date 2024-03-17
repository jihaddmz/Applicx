// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_cart_recharge_voucher.dart';
import 'package:applicx/components/card_gift_credit_transfer.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_permission.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ScreenChargeTouch extends StatefulWidget {
  ScreenChargeTouch({required this.walletAmount});

  final double walletAmount;

  @override
  _ScreenChargeTouch createState() => _ScreenChargeTouch();
}

class _ScreenChargeTouch extends State<ScreenChargeTouch> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  WidgetsToImageController controller = WidgetsToImageController();

  int _tabIndex = 0;
  int _tabIndexVoucherType = 0;
  late final List<ModelGift> list;
  final List<ModelCartVoucher> listOfCartVouchers = [];
  final List<ModelCartVoucher> listOfCartVouchersOthers = [];
  late List<ModelCartVoucher> _listOfChosenVouchers;
  double _walletAmount = 0;
  late BuildContext mContext;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _walletAmount = widget.walletAmount;

    HelperFirebaseFirestore.listenForWalletAmountChanges((p0) {
      if (!mounted) return;
      setState(() {
        _walletAmount = p0;
      });
    });

    list = [
      ModelGift(
          isServiceCreditTransfer: 1,
          title: "Credit Transfer",
          msg: "Specify the amount of credits",
          totalFees: 0),
    ];

    fetchTouchCardVouchers();

    _listOfChosenVouchers = listOfCartVouchers;
  }

  Future<void> fetchTouchCardVouchers() async {
    HelperFirebaseFirestore.fetchCardVouchers((event) {
      listOfCartVouchers.clear();
      listOfCartVouchersOthers.clear();
      for (var element in event.docs) {
        double credits = double.parse(element.id.toString().split("_")[2]);
        int daysAvailability = int.parse(element.id.split("_")[1]);
        String imagePath = credits == 4.5
            ? "assets/images/image_cart_4.png"
            : credits == 7.5
                ? "assets/images/image_cart_2.png"
                : credits == 13.5
                    ? "assets/images/image_cart_6.png"
                    : credits == 1.0
                        ? "assets/images/image_cart_1.png"
                        : credits == 1.67
                            ? "assets/images/image_cart_2.png"
                            : credits == 3.79
                                ? "assets/images/image_cart_3.png"
                                : credits == 4.5
                                    ? "assets/images/image_cart_4.png"
                                    : credits == 7.58
                                        ? "assets/images/image_cart_2.png"
                                        : "assets/images/image_cart_5.png";
        Color color = credits == 1.0 || credits == 4.5
            ? const Color(0xffFDD848)
            : credits == 1.67 || credits == 7.5
                ? const Color(0xffFFB1B6)
                : credits == 3.79 || credits == 13.5
                    ? const Color(0xffBCDBD7)
                    : credits == 4.50
                        ? const Color(0xffCDBCDB)
                        : credits == 7.58
                            ? const Color(0xffAAD59E)
                            : const Color(0xff9ECCFA);
        String instruction = "Dial *14*ActivationCode#";
        Map<String, dynamic> map = element.get("list");

        List<MapEntry<String, dynamic>> list = map.entries.toList()
          ..sort((a, b) => DateTime.parse(a.value.toString())
              .compareTo(DateTime.parse(b.value.toString())));

        Map<String, dynamic> sortedMap = Map.fromEntries(list);

        if (!element.id.contains("CV")) {
          listOfCartVouchersOthers.add(ModelCartVoucher(
              isAlfa: false,
              id: element.id,
              title: element.id.split("_")[0],
              cost: double.parse(element.get("cost")),
              daysAvailability: daysAvailability,
              availability: map.length,
              dolars: credits,
              imagePath: imagePath,
              color: color,
              map: map,
              instruction: instruction));
          // if the card is waffer
        } else {
          // if the card is not waffer
          listOfCartVouchers.add(ModelCartVoucher(
              id: element.id,
              isAlfa: false,
              title: "magic",
              cost: double.parse(element.get("cost")),
              daysAvailability: daysAvailability,
              availability: map.length,
              dolars: credits,
              imagePath: imagePath,
              color: color,
              map: sortedMap,
              instruction: instruction));
        }
      }

      listOfCartVouchersOthers.sort(
        (a, b) => double.parse(a.id.split("_")[2])
            .compareTo(double.parse(b.id.split("_")[2])),
      );

      setListVoucherCardsChosen();
    }, false);
  }

  void setListVoucherCardsChosen() {
    setState(() {
      if (_tabIndexVoucherType == 0) {
        _listOfChosenVouchers = listOfCartVouchers;
      } else {
        _listOfChosenVouchers = listOfCartVouchersOthers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
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
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBoldBlack("Services"),
                      FractionallySizedBox(
                        widthFactor: 0.7,
                        child: TextGrey("Specify the service you want"),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 20,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/logo_touch.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                surfaceTintColor: const Color(0xffF2F2F2),
                color: const Color(0xffF2F2F2),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          top: 0,
                          right: 20,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xffFDD848),
                              child: GestureDetector(
                                onTap: () async {
                                  if (await HelperPermission
                                      .requestContactPermission(context)) {
                                    final PhoneContact contact =
                                        await FlutterContactPicker
                                            .pickPhoneContact();
                                    setState(() {
                                      _controllerName.text =
                                          contact.fullName ?? "";
                                    });
                                    if (contact.phoneNumber != null) {
                                      setState(() {
                                        _controllerPhoneNumber.text =
                                            contact.phoneNumber!.number ?? "";
                                      });
                                    }
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/image_contacts.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: MyTextField(
                                controller: _controllerName,
                                hintText: "User 123 (Optional)",
                                onValueChanged: (text) {},
                                prefixIcon: const Icon(Icons.account_circle),
                                fillColor: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: MyTextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _controllerPhoneNumber,
                                hintText: "76 554 635",
                                onValueChanged: (text) {},
                                prefixIcon: const Icon(Icons.phone),
                                fillColor: Colors.white,
                                inputType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: CardToggler(
                  textLeft: "Gifts",
                  textRight: "Cards Voucher",
                  onToggle: (index) {
                    setState(() {
                      _tabIndex = index;
                      _tabIndexVoucherType = 0;
                    });
                    setListVoucherCardsChosen();
                  }),
            ),
          ),
          Visibility(
              visible: _tabIndex == 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Divider(
                      color: Color(0xff243141),
                      thickness: 4,
                    ),
                  ),
                ),
              )),
          Visibility(
              visible: _tabIndex == 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: listOfGiftCards(),
                ),
              )),
          Visibility(
              visible: _tabIndex == 1,
              child: Column(
                children: [
                  /**                                 Wallet Amount          */
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                                text: "${_walletAmount.toStringAsFixed(2)} \$"),
                            enabled: false,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.center,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xff009CBC), width: 5)),
                                labelText: "Wallet",
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                    color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CardToggler(
                        textLeft: "Magic",
                        textRight: "Other",
                        onToggle: (index) {
                          setState(() {
                            _tabIndexVoucherType = index;
                            if (_tabIndexVoucherType == 0) {
                              _listOfChosenVouchers = listOfCartVouchers;
                            } else {
                              _listOfChosenVouchers = listOfCartVouchersOthers;
                            }
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: listOfCartVouchersWidgets(),
                    ),
                  )
                ],
              ))
        ],
      ),
    )));
  }

  List<Widget> listOfCartVouchersWidgets() {
    List<Widget> result = [];

    for (var element in _listOfChosenVouchers) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CardCartRechargeVoucher(
            modelCartVoucher: element,
            onActionPerformed: (modelCartVoucher, action) async {
              if (_walletAmount < modelCartVoucher.cost) {
                HelperDialog.showDialogInfo(
                    "Warning!",
                    "There is no enough money in your wallet to complete the transaction.",
                    context,
                    () {});
                return;
              }

              if (!await HelperUtils.isConnected()) {
                HelperDialog.showDialogNotConnectedToInternet(context);
                return;
              }

              String phoneNumber =
                  _controllerPhoneNumber.text.toString().replaceAll(" ", "");
              if (action == "buy") {
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
                                          "Touch ${modelCartVoucher.title == "وفّر" ? "Waffer" : ""} ${modelCartVoucher.dolars}\$"),
                                      Image.asset(
                                        "assets/images/logo_touch.png",
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
                                    ButtonSmall(
                                        "Pay ${modelCartVoucher.cost}\$",
                                        () async {
                                      Navigator.pop(mContext);
                                      HelperDialog.showLoadingDialog(mContext,
                                          "Processing Transaction...");
                                      setState(() {
                                        modelCartVoucher.isCardClicked = false;
                                        _walletAmount -= modelCartVoucher.cost;
                                      });
                                      await HelperSharedPreferences
                                          .setWalletAmount(_walletAmount);

                                      await HelperFirebaseFirestore
                                          .setWalletAmount(_walletAmount);

                                      setState(() {
                                        modelCartVoucher.isCardClicked = false;
                                      });

                                      var modelCardVoucher1 =
                                          await HelperFirebaseFirestore
                                              .removeCardVoucher(
                                                  modelCartVoucher);

                                      await HelperFirebaseFirestore
                                          .createCardVoucherHistory(
                                              modelCardVoucher1,
                                              _controllerName.text.isEmpty
                                                  ? await HelperSharedPreferences
                                                      .getUsername()
                                                  : _controllerName.text,
                                              _controllerPhoneNumber
                                                      .text.isEmpty
                                                  ? await HelperSharedPreferences
                                                      .getPhoneNumber()
                                                  : _controllerPhoneNumber
                                                      .text);

                                      await HelperUtils.addPoints(
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
                                                                            "Dial *200*${modelCardVoucher1.map.keys.elementAt(0)}#"),
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
                                                            value.path +
                                                                "/image.png");
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
              } else {
                // action clicked is direct
                if (phoneNumber.length != 8) {
                  HelperDialog.showDialogInfo("Warning!",
                      "Invalid phone number format", context, () => null);
                  scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear);

                  setState(() {
                    modelCartVoucher.isCardClicked = false;
                  });
                  return;
                }

                showDialog(
                    barrierDismissible: false,
                    context: mContext,
                    builder: (context) {
                      return AlertDialog(
                        elevation: 0,
                        backgroundColor: const Color(0xffF2F2F2),
                        title: Center(
                          child: TextBoldBlack("Attention!"),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextGrey(
                                "Are you sure you want to purchase this cart?",
                                textAlign: TextAlign.center),
                            Visibility(
                                visible: _walletAmount < modelCartVoucher.cost,
                                child: TextGrey(
                                    "There is no enough money in your wallet to complete this transaction!!",
                                    textAlign: TextAlign.center,
                                    color: Colors.red)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white,
                                elevation: 2,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        right: 0,
                                        child: Image.asset(
                                          "assets/images/logo_touch.png",
                                          width: 50,
                                          height: 50,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 0, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FractionallySizedBox(
                                            widthFactor: 0.7,
                                            child: TextGrey(
                                                "Cart: ${modelCartVoucher.title} ${modelCartVoucher.dolars}\$"),
                                          ),
                                          TextGrey("Number: ${phoneNumber}"),
                                          TextGrey(
                                              "User: ${_controllerName.text}"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ButtonSmall("No", () {
                                setState(() {
                                  modelCartVoucher.isCardClicked = false;
                                });
                                Navigator.pop(context);
                              }),
                              ButtonSmall("Pay ${modelCartVoucher.cost}\$",
                                  () async {
                                Navigator.pop(mContext);
                                HelperDialog.showLoadingDialog(
                                    mContext, "Processing Transaction...");
                                setState(() {
                                  modelCartVoucher.isCardClicked = false;
                                  _walletAmount -= modelCartVoucher.cost;
                                });
                                await HelperSharedPreferences.setWalletAmount(
                                    _walletAmount);

                                await HelperFirebaseFirestore.setWalletAmount(
                                    _walletAmount);

                                await HelperFirebaseFirestore.createBuyVoucher(
                                    modelCartVoucher, phoneNumber);

                                await HelperFirebaseFirestore.removeCardVoucher(
                                    modelCartVoucher);

                                await HelperFirebaseFirestore
                                    .createCardVoucherHistory(
                                        modelCartVoucher,
                                        _controllerName.text.isEmpty
                                            ? "N/A"
                                            : _controllerName.text,
                                        phoneNumber);

                                await HelperUtils.addPoints(
                                    modelCartVoucher.cost);

                                Navigator.pop(mContext);
                              }, color: const Color(0xffAAD59E)),
                            ],
                          )
                        ],
                      );
                    });
              }
            }),
      ));
    }

    return result;
  }

  List<Widget> listOfGiftCards() {
    List<Widget> result = [];
    for (var element in list) {
      if (element.isServiceCreditTransfer == 1) {
        result.add(CardGiftCreditTransfer(
          isAlfa: false,
          modelGift: element,
          onConfirmClick: (modelGift) {
            String phoneNumber =
                _controllerPhoneNumber.text.toString().replaceAll(" ", "");
            if (phoneNumber.length != 8) {
              HelperDialog.showDialogInfo("Warning!",
                  "Invalid phone number format", context, () => null);
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            } else {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 0,
                      backgroundColor: const Color(0xffF2F2F2),
                      title: Center(
                        child: TextBoldBlack("Attention!"),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextGrey(
                              "Are you sure you want to proceed with this charge?",
                              textAlign: TextAlign.center),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              elevation: 2,
                              child: Stack(
                                children: [
                                  Positioned(
                                      right: 0,
                                      child: Image.asset(
                                        "assets/images/logo_touch.png",
                                        width: 50,
                                        height: 50,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextGrey(
                                            "Credits: ${modelGift.chosen}"),
                                        TextGrey("Number: ${phoneNumber}"),
                                        TextGrey(
                                            "User: ${_controllerName.text}"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonSmall("No", () {
                              setState(() {
                                modelGift.showConfirm = false;
                                modelGift.totalFees = 0.0;
                                modelGift.transfeerFees = 0.0;
                                modelGift.chosen = null;
                              });
                              Navigator.pop(context);
                            }),
                            ButtonSmall("Yes", () async {
                              String result = await sendSMS(
                                  message: "${phoneNumber}t${modelGift.chosen}",
                                  recipients: ["1199"],
                                  sendDirect: false);

                              if (result == "sent") {
                                await HelperFirebaseFirestore
                                    .createGiftVoucherHistory(
                                        modelGift,
                                        _controllerName.text.isEmpty
                                            ? "N/A"
                                            : _controllerName.text,
                                        false,
                                        phoneNumber);
                              }

                              setState(() {
                                modelGift.showConfirm = false;
                                modelGift.totalFees = 0.0;
                                modelGift.transfeerFees = 0.0;
                                modelGift.chosen = null;
                              });

                              Navigator.pop(context);
                            }, color: const Color(0xffAAD59E)),
                          ],
                        )
                      ],
                    );
                  });
            }
          },
        ));
      }
    }

    return result;
  }
}
