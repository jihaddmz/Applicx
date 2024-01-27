import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/item_buy_credit.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_permission.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/models/model_buy_credit.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class ScreenBuyCredits extends StatefulWidget {
  ScreenBuyCredits({required this.walletAmount});

  final double walletAmount;

  @override
  _ScreenBuyCredits createState() => _ScreenBuyCredits();
}

class _ScreenBuyCredits extends State<ScreenBuyCredits> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  String? _textNumberError;
  int _tabIndex = 0;
  double _walletAmount = 0;
  late final listOfCreditsToBuy;

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

    listOfCreditsToBuy = [
      ModelBuyCredit(credits: 1, cost: 1.3, fees: 0.16),
      ModelBuyCredit(credits: 2, cost: 2.3, fees: 0.16),
      ModelBuyCredit(credits: 3, cost: 3.3, fees: 0.16),
    ];
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  child: Column(
                    children: [
                      Image.asset("assets/images/logo_touch.png"),
                      Image.asset("assets/images/logo_alfa.png")
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBoldBlack("Alfa and\nTouch Credits"),
                    TextGrey(
                        "Buy credits from our agent \nwith the lowest cost"),
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
                                        backgroundColor:
                                            const Color(0xffFDD848),
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
                                                      contact.phoneNumber!
                                                              .number ??
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
                                          onValueChanged: (text) {
                                            setState(() {
                                              _textNumberError = null;
                                            });
                                          },
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: CardToggler(
                            textLeft: "Alfa",
                            iconLeft: Image.asset("assets/images/logo_alfa.png",
                                width: 20, height: 20),
                            textRight: "Touch",
                            iconRight: Image.asset(
                                "assets/images/logo_touch.png",
                                width: 20,
                                height: 20),
                            onToggle: (index) {
                              setState(() {
                                _tabIndex = index;
                              });
                            }),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Padding(
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
                                          borderSide: BorderSide(
                                              color: Color(_tabIndex == 0
                                                  ? 0xffFF6F77
                                                  : 0xff009CBC),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: widgetOfCredits(),
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

  List<Widget> widgetOfCredits() {
    List<Widget> result = [];

    for (var element in listOfCreditsToBuy) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemBuyCredit(element, _tabIndex, (modelBuyCredit) {
          if (_controllerPhoneNumber.text.isEmpty) {
            setState(() {
              _textNumberError = "Please enter a phone number";
            });
            return;
          }
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
                      TextNote("It may take up to 5 min to transfer credits",
                          textAlign: TextAlign.center),
                      Visibility(
                          visible: _walletAmount < modelBuyCredit.cost,
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
                                  child: Image.asset(_tabIndex == 0
                                      ? "assets/images/logo_alfa.png"
                                      : "assets/images/logo_touch.png")),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextGrey(
                                        "Credits: ${modelBuyCredit.credits}\$"),
                                    TextGrey(
                                        "Number: ${_controllerPhoneNumber.text}"),
                                    TextGrey("User: ${_controllerName.text}"),
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
                          Navigator.pop(context);
                        }),
                        ButtonSmall(
                            "Pay ${modelBuyCredit.cost + modelBuyCredit.fees}\$",
                            () async {
                          if (_walletAmount >= modelBuyCredit.cost) {
                            setState(() {
                              _walletAmount -= modelBuyCredit.cost;
                            });

                            await HelperFirebaseFirestore.setWalletAmount(
                                _walletAmount);

                            await HelperSharedPreferences.setWalletAmount(
                                _walletAmount);
                            Navigator.pop(context);
                          }
                        }, color: const Color(0xffAAD59E)),
                      ],
                    )
                  ],
                );
              });
        }),
      ));
    }

    return result;
  }
}
