import 'package:applicx/components/button.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:flutter/material.dart';

class CardCartRechargeVoucher extends StatefulWidget {
  const CardCartRechargeVoucher(
      {required this.modelCartVoucher, required this.onActionPerformed});

  final ModelCartVoucher modelCartVoucher;
  final Function(ModelCartVoucher, String) onActionPerformed;

  @override
  _CardCartRechargeVoucher createState() => _CardCartRechargeVoucher();
}

class _CardCartRechargeVoucher extends State<CardCartRechargeVoucher> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.modelCartVoucher.map.isEmpty) {
          return;
        }
        setState(() {
          widget.modelCartVoucher.isCardClicked = true;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Card(
          surfaceTintColor: const Color(0xffF2F2F2),
          color: widget.modelCartVoucher.isCardClicked
              ? Colors.transparent
              : widget.modelCartVoucher.color,
          elevation: 4,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextNormalBlack(widget.modelCartVoucher.title),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(widget.modelCartVoucher.isAlfa
                      ? "assets/images/logo_alfa.png"
                      : "assets/images/logo_touch.png"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 80, 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(widget.modelCartVoucher.imagePath),
                ),
              ),
              Positioned(
                  bottom: 15,
                  left: 8,
                  child: TextBoldBlack("\$${widget.modelCartVoucher.cost}")),
              Positioned(
                  bottom: 0,
                  left: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextGrey("(all taxes excluded)"),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: TextGrey(
                      "${widget.modelCartVoucher.daysAvailability} Days"),
                ),
              ),
              Visibility(
                  visible: widget.modelCartVoucher.isCardClicked ||
                      widget.modelCartVoucher.map.isEmpty,
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Card(
                      color: widget.modelCartVoucher.map.isEmpty
                          ? const Color.fromRGBO(255, 255, 255, 0.8)
                          : const Color(0xffF9F9F9),
                      elevation: 2,
                      child: Stack(
                        children: [
                          Visibility(
                              visible: widget.modelCartVoucher.map.isNotEmpty,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.modelCartVoucher.isCardClicked =
                                            false;
                                      });
                                    },
                                    icon: const Icon(Icons.close_rounded)),
                              )),
                          Align(
                            alignment: Alignment.center,
                            child: widget.modelCartVoucher.map.isEmpty
                                ? TextLessBoldBlack("Not Available")
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Button("Buy", () {
                                        widget.onActionPerformed(
                                            widget.modelCartVoucher, "buy");
                                      }, color: const Color(0xffAAD59E)),
                                      Button("Direct", () {
                                        widget.onActionPerformed(
                                            widget.modelCartVoucher, "direct");
                                      }, color: const Color(0xffAAD59E)),
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
