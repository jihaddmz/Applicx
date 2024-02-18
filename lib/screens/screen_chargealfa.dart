// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_cart_recharge_voucher.dart';
import 'package:applicx/components/card_gift_credit_transfer.dart';
import 'package:applicx/components/card_gift_others.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/helpers/helper_permission.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class ScreenChargeAlfa extends StatefulWidget {
  ScreenChargeAlfa({required this.walletAmount});

  final double walletAmount;

  @override
  _ScreenChargeAlfa createState() => _ScreenChargeAlfa();
}

class _ScreenChargeAlfa extends State<ScreenChargeAlfa> {
  static const platform = MethodChannel("sendSmss");

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  String? _textNumberError;
  int _tabIndex = 0;
  int _tabIndexVoucherType = 0;
  late final List<ModelGift> list;
  final List<ModelCartVoucher> listOfCartVouchers = [];
  List<ModelCartVoucher> listOfCartVouchersWaffer = [];
  List<ModelCartVoucher> _listOfChosenVouchers = [];
  double _walletAmount = 0;
  late BuildContext mContext;

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

    fetchAlfaCardVouchers();

    list = [
      ModelGift(
          isServiceCreditTransfer: 1,
          title: "Credit Transfer",
          msg: "Specify the amount of credits",
          totalFees: 0),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "Mobile Internet",
          msg: "Specify the amount of GBs",
          availability: "30 Days",
          cost: 0,
          color: const Color(0xffFFB1B6),
          listOfOptions: const [
            "0.5:3.5",
            "1.5:5.50",
            "5:7.50",
            "10:10",
            "20:13",
            "30:15.50",
            "40:19.50",
            "60:23",
            "70:26",
            "100:35.50",
            "200:64.50"
          ]),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "Weekly Data Bundle",
          msg: "Specify the amount of GBs",
          availability: "7 Days",
          cost: 0,
          color: const Color(0xffCDBCDB),
          listOfOptions: const ["0.5:1.67", "1.5:2.34", "5:5"]),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "Data Booster",
          msg: "Specify the amount of GBs",
          availability: "... Days",
          cost: 0,
          color: const Color(0xffFDD848),
          listOfOptions: const ["Unlimited:1.67", "0.05:0.34", "0.6:1"]),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "Alfa 4x4 / 5x5",
          msg: "Specify which service",
          availability: "30 Days",
          cost: 0,
          color: const Color(0xffBCDBD7),
          listOfOptions: const ["4x4:4", "5x5:1.67"]),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "Minutes Booster 20 Min",
          msg: "Recharge 20 Mins call for anyone",
          availability: "Tomorrow Midnight",
          cost: 0.34,
          color: const Color(0xffAAD59E)),
      ModelGift(
          isServiceCreditTransfer: 0,
          title: "The Weekender",
          msg: "Recharge the weekender service",
          availability: "Weekend",
          cost: 1.34,
          color: const Color(0xffFACA9E)),
    ];
  }

  Future<void> fetchAlfaCardVouchers() async {
    HelperFirebaseFirestore.fetchCardVouchers((event) {
      listOfCartVouchers.clear();
      listOfCartVouchersWaffer.clear();
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

        if (element.id.contains("W")) {
          listOfCartVouchersWaffer.add(ModelCartVoucher(
              isAlfa: true,
              id: element.id,
              title: "وفّر",
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
      }

      listOfCartVouchersWaffer.sort(
        (a, b) => b.id.split("_")[2].compareTo(a.id.split("_")[2]),
      );

      setListVoucherCardsChosen();
    }, true);
  }

  void setListVoucherCardsChosen() {
    setState(() {
      if (_tabIndexVoucherType == 0) {
        _listOfChosenVouchers = listOfCartVouchers;
      } else {
        _listOfChosenVouchers = listOfCartVouchersWaffer;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/image_back.png"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Positioned(
                          right: 0,
                          child: Image.asset("assets/images/logo_alfa.png")),
                    )
                  ],
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
                                                contact.phoneNumber!.number ??
                                                    "";
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
                                    prefixIcon:
                                        const Icon(Icons.account_circle),
                                    fillColor: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: MyTextField(
                                    controller: _controllerPhoneNumber,
                                    hintText: "76 554 635",
                                    onValueChanged: (text) {
                                      _textNumberError = null;
                                    },
                                    prefixIcon: const Icon(Icons.phone),
                                    fillColor: Colors.white,
                                    inputType: TextInputType.phone,
                                    errorText: _textNumberError,
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
                          setListVoucherCardsChosen();
                        });
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Visibility(
                    visible: _tabIndex == 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: listOfGiftCards(),
                      ),
                    )),
              ),
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
                                    text:
                                        "${_walletAmount.toStringAsFixed(2)} \$"),
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
                                            color: Color(0xffFF6F77),
                                            width: 5)),
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
                            textLeft: "Original",
                            textRight: "وفّر",
                            onToggle: (index) {
                              setState(() {
                                _tabIndexVoucherType = index;
                                if (_tabIndexVoucherType == 0) {
                                  _listOfChosenVouchers = listOfCartVouchers;
                                } else {
                                  _listOfChosenVouchers =
                                      listOfCartVouchersWaffer;
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
        ));
  }

  List<Widget> listOfCartVouchersWidgets() {
    List<Widget> result = [];

    for (var element in _listOfChosenVouchers) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CardCartRechargeVoucher(
            modelCartVoucher: element,
            onActionPerformed: (modelCartVoucher, action) {
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
                              Visibility(
                                  visible:
                                      _walletAmount < modelCartVoucher.cost,
                                  child: TextGrey(
                                      "There is no enough money in your wallet to complete this transaction!!",
                                      textAlign: TextAlign.center,
                                      color: Colors.red)),
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
                                          "Alfa ${modelCartVoucher.title == "وفّر" ? "Waffer" : ""} ${modelCartVoucher.cost}\$"),
                                      Image.asset("assets/images/logo_alfa.png")
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
                                      if (await HelperUtils.isConnected()) {
                                        if (_walletAmount >=
                                            modelCartVoucher.cost) {
                                          // there is enough money in the wallet
                                          setState(() {
                                            _walletAmount -=
                                                modelCartVoucher.cost;
                                          });

                                          await HelperFirebaseFirestore
                                              .setWalletAmount(_walletAmount);
                                          await HelperSharedPreferences
                                              .setWalletAmount(_walletAmount);
                                          setState(() {
                                            modelCartVoucher.isCardClicked =
                                                false;
                                          });
                                          Navigator.pop(mContext);

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

                                          showDialog(
                                              context: mContext,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      const Color(0xffF2F2F2),
                                                  title: Align(
                                                    alignment: Alignment.center,
                                                    child: TextBoldBlack(
                                                        "Share Info"),
                                                  ),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: TextGrey(
                                                            "You will share the purchased cart as an image",
                                                            textAlign: TextAlign
                                                                .center),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 20),
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
                                                                            40,
                                                                        height:
                                                                            40,
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
                                                                            "Dial *14*${modelCardVoucher1.map.keys.elementAt(0)}#"),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 10),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                TextNormalBlack("${modelCardVoucher1.cost}\$", textAlign: TextAlign.right),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  actions: [
                                                    ButtonSmall("Save", () {
                                                      Navigator.pop(mContext);
                                                    },
                                                        color: const Color(
                                                            0xff9ECCFA)),
                                                    ButtonSmall("Share", () {},
                                                        color: const Color(
                                                            0xffAAD59E))
                                                  ],
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                );
                                              });
                                        } else {
                                          HelperDialog.showDialogInfo(
                                              "Attention!",
                                              "There is no enough money in your wallet",
                                              mContext, () {
                                            Navigator.of(mContext).pop();
                                          });
                                        }
                                      } else {
                                        HelperDialog
                                            .showDialogNotConnectedToInternet(
                                                mContext);
                                      }
                                    }, color: const Color(0xffAAD59E))
                                  ],
                                ),
                              )
                            ],
                          ));
                    });
              } else {
                if (_controllerPhoneNumber.text.isEmpty) {
                  setState(() {
                    _textNumberError = "Please enter a phone number";
                    modelCartVoucher.isCardClicked = false;
                  });
                  return;
                }
                // action clicked is direct
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
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        right: 0,
                                        child: Image.asset(
                                            "assets/images/logo_alfa.png")),
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
                                                "Cart: ${modelCartVoucher.title == "وفّر" ? "Waffer" : ""} ${modelCartVoucher.cost}\$"),
                                          ),
                                          TextGrey(
                                              "Number: ${_controllerPhoneNumber.text}"),
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
                                Navigator.pop(mContext);
                              }),
                              ButtonSmall("Pay ${modelCartVoucher.cost}\$",
                                  () async {
                                if (await HelperUtils.isConnected()) {
                                  if (_walletAmount >= modelCartVoucher.cost) {
                                    setState(() {
                                      modelCartVoucher.isCardClicked = false;
                                      _walletAmount -= modelCartVoucher.cost;
                                    });
                                    await HelperFirebaseFirestore
                                        .setWalletAmount(_walletAmount);
                                    await HelperSharedPreferences
                                        .setWalletAmount(_walletAmount);

                                    await HelperFirebaseFirestore
                                        .createBuyVoucher(modelCartVoucher,
                                            _controllerPhoneNumber.text);

                                    await HelperFirebaseFirestore
                                        .removeCardVoucher(modelCartVoucher);

                                    await HelperFirebaseFirestore
                                        .createCardVoucherHistory(
                                            modelCartVoucher,
                                            _controllerName.text.isEmpty
                                                ? "N/A"
                                                : _controllerName.text,
                                            _controllerPhoneNumber.text);

                                    Navigator.pop(mContext);
                                  } else {
                                    HelperDialog.showDialogInfo(
                                        "Attention!",
                                        "There is no enough money in your wallet.",
                                        mContext, () {
                                      Navigator.pop(mContext);
                                    });
                                  }
                                } else {
                                  HelperDialog.showDialogNotConnectedToInternet(
                                      mContext);
                                }
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
          modelGift: element,
          onConfirmClick: (modelGift, controller) {
            if (_controllerPhoneNumber.text.isEmpty) {
              setState(() {
                _textNumberError = "Please enter a phone number";
              });
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
                          TextNote(
                              "It may take up to 5 min to transfer credits",
                              textAlign: TextAlign.center),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              elevation: 0,
                              child: Stack(
                                children: [
                                  Positioned(
                                      right: 0,
                                      child: Image.asset(
                                          "assets/images/logo_alfa.png")),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextGrey(
                                            "Credits: ${modelGift.chosen}"),
                                        TextGrey(
                                            "Number: ${_controllerPhoneNumber.text}"),
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
                                controller.clear();
                              });
                              Navigator.pop(mContext);
                            }),
                            ButtonSmall("Yes", () async {
                              String result = await sendSMS(
                                  message:
                                      "${_controllerPhoneNumber.text}t${controller.text}",
                                  recipients: ["1313"],
                                  sendDirect: false);

                              // await platform.invokeMethod('sendSmsIn',
                              //     {"phoneNumber": "+96176554635", "msg": "hello there world!"});

                              setState(() {
                                modelGift.showConfirm = false;
                                modelGift.totalFees = 0.0;
                                modelGift.transfeerFees = 0.0;
                                controller.clear();
                              });
                              if (result == "sent") {
                                await HelperFirebaseFirestore
                                    .createGiftVoucherHistory(
                                        modelGift,
                                        _controllerName.text.isEmpty
                                            ? "N/A"
                                            : _controllerName.text,
                                        true,
                                        _controllerPhoneNumber.text);
                              }

                              Navigator.pop(mContext);
                            }, color: const Color(0xffAAD59E)),
                          ],
                        )
                      ],
                    );
                  });
            }
          },
        ));
      } else {
        result.add(CardGiftOthers(
          modelGift: element,
          color: element.color!,
          list: element.msg.contains("Specify") ? element.listOfOptions! : null,
          onConfirmClick: (modelGift) {
            if (_controllerPhoneNumber.text.isEmpty) {
              setState(() {
                _textNumberError = "Please enter a phone number";
              });
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white,
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        right: 0,
                                        top: 5,
                                        child: Image.asset(
                                            "assets/images/logo_alfa.png")),
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
                                                "Service: ${modelGift.title}"),
                                          ),
                                          Visibility(
                                              visible: modelGift.chosen != null,
                                              child: TextGrey(modelGift.msg
                                                      .contains("GB")
                                                  ? "GB: ${modelGift.chosen}"
                                                  : "Service: ${modelGift.chosen}")),
                                          TextGrey(
                                              "Number: ${_controllerPhoneNumber.text}"),
                                          TextGrey(
                                              "User: ${_controllerName.text}"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
                                if (modelGift.msg.contains("Specify")) {
                                  setState(() {
                                    modelGift.cost = 0;
                                    modelGift.chosen = null;
                                  });
                                }
                              });
                              Navigator.pop(context);
                            }),
                            ButtonSmall("Yes", () async {
                              String result = "";

                              if (modelGift.title == "Mobile Internet") {
                                result = await sendSMS(
                                    message:
                                        "${_controllerPhoneNumber.text}MI${modelGift.chosen == "0.5" ? "500" : modelGift.chosen}",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              } else if (modelGift.title ==
                                  "Weekly Data Bundle") {
                                result = await sendSMS(
                                    message:
                                        "${_controllerPhoneNumber.text}WDB${modelGift.chosen == "0.5" ? "500" : modelGift.chosen}",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              } else if (modelGift.title == "Data Booster") {
                                var chosenParameter = "";
                                if (modelGift.chosen == "Unlimited") {
                                  chosenParameter = "D5";
                                } else if (modelGift.chosen == "0.05") {
                                  chosenParameter = "D1";
                                } else if (modelGift.chosen == "0.6") {
                                  chosenParameter = "D3";
                                }

                                result = await sendSMS(
                                    message:
                                        "${_controllerPhoneNumber.text}${chosenParameter}",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              } else if (modelGift.title == "Alfa 4x4 / 5x5") {
                                result = await sendSMS(
                                    message:
                                        "${_controllerPhoneNumber.text}${modelGift.chosen == "4x4" ? "A4" : "ND5"}",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              } else if (modelGift.title ==
                                  "Minutes Booster 20 Min") {
                                result = await sendSMS(
                                    message: "${_controllerPhoneNumber.text}M1",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              } else if (modelGift.title == "The Weekender") {
                                result = await sendSMS(
                                    message: "${_controllerPhoneNumber.text}TW",
                                    recipients: ["1050"],
                                    sendDirect: false);
                              }

                              if (modelGift.msg.contains("Specify")) {
                                setState(() {
                                  modelGift.cost = 0;
                                  modelGift.chosen = null;
                                });
                              }
                              if (result == "sent") {
                                await HelperFirebaseFirestore
                                    .createGiftVoucherHistory(
                                        modelGift,
                                        _controllerName.text.isEmpty
                                            ? "N/A"
                                            : _controllerName.text,
                                        true,
                                        _controllerPhoneNumber.text);
                              }

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
