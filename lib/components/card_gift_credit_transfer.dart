import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardGiftCreditTransfer extends StatefulWidget {
  CardGiftCreditTransfer(
      {required this.modelGift, required this.onConfirmClick});

  final ModelGift modelGift;
  final Function(ModelGift) onConfirmClick;

  @override
  _CardGiftCreditTransfer createState() => _CardGiftCreditTransfer();
}

class _CardGiftCreditTransfer extends State<CardGiftCreditTransfer> {
  final TextEditingController _controller = TextEditingController();

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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Card(
                                            surfaceTintColor:
                                                const Color(0xffF2F2F2),
                                            elevation: 4,
                                            shape: const RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: SizedBox(
                                              width: 60,
                                              height: 40,
                                              child: TextField(
                                                controller: _controller,
                                                textAlign: TextAlign.center,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      3),
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "...",
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    setState(() {
                                                      widget.modelGift.chosen =
                                                          value;
                                                      widget.modelGift
                                                              .totalFees =
                                                          double.parse(value);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      widget.modelGift.chosen =
                                                          null;
                                                      widget.modelGift
                                                          .totalFees = 0;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          TextGrey("Credits")
                                        ],
                                      )),
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
