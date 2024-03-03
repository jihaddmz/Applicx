import 'package:applicx/colors.dart';
import 'package:applicx/components/fab_scrolltotop.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/models/model_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenSettingsPayments extends StatefulWidget {
  ScreenSettingsPayments({required this.walletAmount});

  final double walletAmount;

  @override
  _ScreenSettingsPayments createState() => _ScreenSettingsPayments();
}

class _ScreenSettingsPayments extends State<ScreenSettingsPayments> {
  List<ModelPayment> _list = [];
  final ScrollController scrollController = ScrollController();
  

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      fetchPayments();
    });
  }

  Future<void> fetchPayments() async {
    HelperDialog.showLoadingDialog(context, "Fetching Payments History");
    List<ModelPayment> result = [];
    await HelperFirebaseFirestore.fetchPayments().then((value) {
      if (value != null) {
        for (var element in value) {
          result.add(ModelPayment(
              title: element["serviceTitle"],
              cost: double.parse(element["amountPaid"]),
              date: element["date"]));
        }
      }
    });

    setState(() {
      _list = result;
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextBoldBlack("Payments"),
                  ),
                  TextGrey("View your previous payments"),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextField(
                        controller: TextEditingController(
                            text: "${widget.walletAmount} \$"),
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
                            TextEditingController(text: "${_list.length}"),
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
                                    color: Colors.black, width: 3)),
                            labelText: "Total Payments",
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
                      children: widgetsOfPayments(),
                    ),
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
          padding: const EdgeInsets.only(top: 30),
          child: ItemPayment(element)));
    }

    return result;
  }

  Widget ItemPayment(ModelPayment modelPayment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Card(
          color: colorDarkBlue,
          shape: OvalBorder(side: BorderSide.none),
          child: Padding(padding: EdgeInsets.all(5)),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Card(
            elevation: 4,
            color: colorCard,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextNormalBlack("${modelPayment.cost}\$"),
                      TextNormalBlack(modelPayment.title)
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextGrey(modelPayment.date,
                        fontStyle: FontStyle.italic, fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
