import 'package:applicx/components/drop_down.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';

class CardGiftCreditTransfer extends StatefulWidget {
  CardGiftCreditTransfer(
      {required this.modelGift, required this.onConfirmClick});

  final ModelGift modelGift;
  final Function(ModelGift) onConfirmClick;

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
              widget.onConfirmClick(widget.modelGift);
            },
            child: Visibility(
                visible: widget.modelGift.chosen != null,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Positioned(
                      bottom: -30,
                      child: Card(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextNormalBlack(widget.modelGift.title),
                        TextGrey(widget.modelGift.msg),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextGrey(
                                    "Total Fees: ${widget.modelGift.totalFees}\$"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: MyDropDown(
                                      list: const ["1", "2", "3"],
                                      label: "Credits",
                                      onSelect: (item) => {
                                            setState(() {
                                              widget.modelGift.chosen = item;
                                              widget.modelGift.totalFees =
                                                  double.parse(item!);
                                            })
                                          }),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
