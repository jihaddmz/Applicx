import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_deposit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenSettingsDeposit extends StatefulWidget {
  @override
  _ScreenSettingsDeposit createState() => _ScreenSettingsDeposit();
}

class _ScreenSettingsDeposit extends State<ScreenSettingsDeposit> {
  double _walletAmount = 100;
  int _depositsLength = 10;
  late final List<ModelDeposit> _list;

  @override
  void initState() {
    super.initState();
    _list = [
      ModelDeposit(amount: 100, date: "10/05/2023 12:00:00 AM"),
      ModelDeposit(amount: 10, date: "10/05/2023 12:00:00 AM"),
      ModelDeposit(amount: 50, date: "10/05/2023 12:00:00 AM")
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBoldBlack("Deposits"),
              TextGrey("Check all your previous deposits"),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    controller:
                        TextEditingController(text: "${_walletAmount} \$"),
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
                                color: Colors.black, width: 3)),
                        labelText: "Wallet",
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    controller:
                        TextEditingController(text: "${_depositsLength}"),
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
                                color: Colors.black, width: 3)),
                        labelText: "Total Deposits",
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: widgetsOfDeposits(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> widgetsOfDeposits() {
    List<Widget> result = [];

    for (var element in _list) {
      result.add(Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ItemDeposit(element)));
    }

    return result;
  }

  Widget ItemDeposit(ModelDeposit modelDeposit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/svgs/vector_circle_black.svg"),
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 5, 4),
              child: Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextNormalBlack(
                      "${modelDeposit.amount}\$ deposit successfully"),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextGrey(modelDeposit.date),
                  )
                ],
              )),
            ),
          ),
        ),
      ],
    );
  }
}
