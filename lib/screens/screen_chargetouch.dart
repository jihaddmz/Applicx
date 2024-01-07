// ignore_for_file: use_build_context_synchronously

import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_cart_recharge_voucher.dart';
import 'package:applicx/components/card_gift_credit_transfer.dart';
import 'package:applicx/components/card_gift_others.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/helpers/helper_permission.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class ScreenChargeTouch extends StatefulWidget {
  ScreenChargeTouch({required this.walletAmount});

  final double walletAmount;

  @override
  _ScreenChargeTouch createState() => _ScreenChargeTouch();
}

class _ScreenChargeTouch extends State<ScreenChargeTouch> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  String? _textNumberError;
  int _tabIndex = 0;
  int _tabIndexVoucherType = 0;
  late final List<ModelGift> list;
  late final List<ModelCartVoucher> listOfCartVouchers;
  late final List<ModelCartVoucher> listOfCartVouchersOthers;
  late List<ModelCartVoucher> _listOfChosenVouchers;
  double _walletAmount = 0;

  @override
  void initState() {
    super.initState();
    _walletAmount = widget.walletAmount;
    list = [
      ModelGift(
          isServiceCreditTransfer: 1,
          title: "Credit Transfer",
          msg: "Specify the amount of credits",
          totalFees: 0),
    ];

    listOfCartVouchers = [
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 1.00,
          availability: 0,
          dolars: 2,
          imagePath: "assets/images/image_cart_1.png",
          color: const Color(0xffFDD848),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 1.67,
          availability: 0,
          dolars: 3,
          imagePath: "assets/images/image_cart_2.png",
          color: const Color(0xffFFB1B6),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 3.79,
          availability: 10,
          dolars: 4,
          imagePath: "assets/images/image_cart_2.png",
          color: const Color(0xffBCDBD7),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 4.50,
          availability: 30,
          dolars: 4,
          imagePath: "assets/images/image_cart_4.png",
          color: const Color(0xffCDBCDB),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 7.58,
          availability: 30,
          dolars: 5,
          imagePath: "assets/images/image_cart_5.png",
          color: const Color(0xffAAD59E),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "magic",
          cost: 15.15,
          availability: 60,
          dolars: 5,
          imagePath: "assets/images/image_cart_6.png",
          color: const Color(0xffAAD59E),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#")
    ];

    listOfCartVouchersOthers = [
      ModelCartVoucher(
          isAlfa: false,
          title: "Start",
          cost: 4.50,
          availability: 30,
          dolars: 5,
          imagePath: "assets/images/image_cart_4.png",
          color: const Color(0xffFDD848),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "Smart",
          cost: 7.50,
          availability: 30,
          dolars: 5,
          imagePath: "assets/images/image_cart_2.png",
          color: const Color(0xffFFB1B6),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#"),
      ModelCartVoucher(
          isAlfa: false,
          title: "Super",
          cost: 13.50,
          availability: 30,
          dolars: 5,
          imagePath: "assets/images/image_cart_6.png",
          color: const Color(0xffBCDBD7),
          actCode: "12312312243241123123213321321312",
          expDate: "2023-02-15 12:00:00 AM",
          instruction: "Dial *14*ActivationCode#")
    ];

    _listOfChosenVouchers = listOfCartVouchers;
  }

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
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
                          child: Image.asset("assets/images/logo_touch.png")),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                                            .requestContactPermission(
                                                context)) {
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
                Visibility(
                    visible: _tabIndex == 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: Color(0xff009CBC),
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
                              textLeft: "Magic",
                              textRight: "Other",
                              onToggle: (index) {
                                setState(() {
                                  _tabIndexVoucherType = index;
                                  if (_tabIndexVoucherType == 0) {
                                    _listOfChosenVouchers = listOfCartVouchers;
                                  } else {
                                    _listOfChosenVouchers =
                                        listOfCartVouchersOthers;
                                  }
                                });
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: listOfCartVouchersWidgets(),
                          ),
                        )
                      ],
                    ))
              ],
            ),
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
              if (_controllerPhoneNumber.text.isEmpty) {
                setState(() {
                  _textNumberError = "Please enter a phone number";
                  modelCartVoucher.isCardClicked = false;
                });
                return;
              }
              if (action == "buy") {
                showDialog(
                    barrierDismissible: false,
                    context: context,
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
                                      Image.asset(
                                          "assets/images/logo_touch.png")
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
                                      Navigator.pop(context);
                                    }, color: const Color(0xffFF6F77)),
                                    ButtonSmall(
                                        "Pay ${modelCartVoucher.cost}\$",
                                        () async {
                                      if (_walletAmount >=
                                          modelCartVoucher.cost) {
                                        setState(() {
                                          modelCartVoucher.isCardClicked =
                                              false;
                                          _walletAmount -=
                                              modelCartVoucher.cost;
                                        });
                                        await HelperSharedPreferences
                                            .setWalletAmount(_walletAmount);
                                        Navigator.pop(context);
                                      }
                                    }, color: const Color(0xffAAD59E))
                                  ],
                                ),
                              )
                            ],
                          ));
                    });
              } else {
                // action clicked is direct
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
                                            "assets/images/logo_touch.png")),
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
                                                "Cart: ${modelCartVoucher.title} ${modelCartVoucher.cost}\$"),
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
                                Navigator.pop(context);
                              }),
                              ButtonSmall("Pay ${modelCartVoucher.cost}\$",
                                  () async {
                                if (_walletAmount >= modelCartVoucher.cost) {
                                  setState(() {
                                    modelCartVoucher.isCardClicked = false;
                                    _walletAmount -= modelCartVoucher.cost;
                                  });
                                  await HelperSharedPreferences.setWalletAmount(
                                      _walletAmount);
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          elevation: 0,
                                          backgroundColor:
                                              const Color(0xffF2F2F2),
                                          title: Align(
                                            alignment: Alignment.center,
                                            child: TextBoldBlack("Share Info"),
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
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Card(
                                                  elevation: 2,
                                                  color:
                                                      const Color(0xffffffff),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            TextNormalBlack(
                                                                "Activation Code"),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child:
                                                                  Image.asset(
                                                                !modelCartVoucher
                                                                        .isAlfa
                                                                    ? "assets/images/logo_touch.png"
                                                                    : "assets/images/logo_alfa.png",
                                                                width: 40,
                                                                height: 40,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        TextGrey(
                                                            modelCartVoucher
                                                                .actCode),
                                                        TextNormalBlack(
                                                            "Expiration Date"),
                                                        TextGrey(
                                                            modelCartVoucher
                                                                .expDate),
                                                        TextNormalBlack(
                                                            "Instruction"),
                                                        TextGrey(
                                                            "Dial *14*${modelCartVoucher.actCode}#"),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: TextNormalBlack(
                                                              "${modelCartVoucher.cost}\$",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            ButtonSmall("Save", () {
                                              Navigator.pop(context);
                                            }, color: const Color(0xff9ECCFA)),
                                            ButtonSmall("Share", () {},
                                                color: const Color(0xffAAD59E))
                                          ],
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                        );
                                      });
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
                          TextNote(
                              "It may take up to 5 min to transfer credits",
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
                                          "assets/images/logo_touch.png")),
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
                                modelGift.totalFees = 0;
                                modelGift.chosen = null;
                              });
                              Navigator.pop(context);
                            }),
                            ButtonSmall("Pay ${modelGift.totalFees}\$", () {
                              setState(() {
                                modelGift.totalFees = 0;
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
                          TextGrey("Are you sure you want to charge this?",
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
                                              "Cart: ${modelGift.title}"),
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
                            ButtonSmall("Pay ${modelGift.cost}\$", () {
                              setState(() {
                                if (modelGift.msg.contains("Specify")) {
                                  setState(() {
                                    modelGift.cost = 0;
                                    modelGift.chosen = null;
                                  });
                                }
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
