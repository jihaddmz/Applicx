import 'package:applicx/components/drop_down.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';

class CardGiftCreditTransfer extends StatefulWidget {
  CardGiftCreditTransfer(
      {required this.modelGift,
      required this.onConfirmClick,
      required this.isAlfa});

  final ModelGift modelGift;
  final Function(ModelGift) onConfirmClick;
  final bool isAlfa;

  @override
  _CardGiftCreditTransfer createState() => _CardGiftCreditTransfer();
}

class _CardGiftCreditTransfer extends State<CardGiftCreditTransfer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              calculateTotalCreditsFees();
              widget.onConfirmClick(widget.modelGift);
            },
            child: Visibility(
                visible: widget.modelGift.showConfirm,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Positioned(
                      bottom: -30,
                      child: Card(
                        elevation: 0,
                        color: const Color(0xff243141),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 2),
                          child: Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                )),
          ),
          SizedBox(
            height: 150,
            child: Card(
              color: const Color(0xff9ECCFA),
              surfaceTintColor: const Color(0xffF2F2F2),
              elevation: 4,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 150,
                    width: 20,
                    child: Card(
                      color: Color(0xff243141),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 0,
                                  bottom: 20,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            MyDropDown(
                                                list: const [
                                                  "0.5",
                                                  "1",
                                                  "1.5",
                                                  "2",
                                                  "2.5",
                                                  "3"
                                                ],
                                                label: "",
                                                initialSelected:
                                                    widget.modelGift.chosen,
                                                onSelect: (value) {
                                                  if (value != null &&
                                                      !doesContainWrongCreditDeciml(
                                                          value)) {
                                                    setState(() {
                                                      widget.modelGift
                                                          .showConfirm = true;
                                                      widget.modelGift.chosen =
                                                          value;
                                                      widget.modelGift
                                                              .totalFees =
                                                          calculateTotalCreditsFees() +
                                                              double.parse(
                                                                  widget
                                                                      .modelGift
                                                                      .chosen!);
                                                      widget.modelGift
                                                              .transfeerFees =
                                                          double.parse(
                                                              calculateTotalCreditsFees()
                                                                  .toStringAsFixed(
                                                                      2));
                                                    });
                                                  } else {
                                                    setState(() {
                                                      widget.modelGift
                                                          .showConfirm = false;
                                                      widget.modelGift
                                                          .totalFees = 0;
                                                      widget.modelGift
                                                          .transfeerFees = 0;
                                                    });
                                                  }
                                                }),
                                          ],
                                        )),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextNormalBlack(widget.modelGift.title),
                                  TextGrey(widget.modelGift.msg),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextGrey(
                                        "Transfer Fees: ${widget.modelGift.transfeerFees}\$"),
                                  ),
                                  TextGrey(
                                      "Total Cost: ${widget.modelGift.totalFees!.toStringAsFixed(2)}\$"),
                                ],
                              )
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool doesContainWrongCreditDeciml(String text) {
    return RegExp(r'\.(1|2|3|4|6|7|8|9)').hasMatch(text);
  }

  double calculateTotalCreditsFees() {
    var moduloCheck = 0.0;

    if (widget.modelGift.chosen != null) {
      moduloCheck = double.parse(widget.modelGift.chosen!) % 3;
      if (moduloCheck > 0) {
        moduloCheck = 1;
      } else {
        moduloCheck = 0;
      }

      var results = double.parse(widget.modelGift.chosen!) / 3;

      var transfeerFeesByCarrier = widget.isAlfa ? 0.14 : 0.16;

      var transferFees = results.toInt() * transfeerFeesByCarrier + moduloCheck * transfeerFeesByCarrier;

      return transferFees;
    } else {
      return 0;
    }
  }
}
