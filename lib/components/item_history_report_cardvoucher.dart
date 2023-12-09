import 'package:applicx/components/card_paid_status.dart';
import 'package:applicx/components/card_unpaid_status.dart';
import 'package:applicx/components/oval_letter.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_history_report_vouchercard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget ItemHistoryReportCardVoucher(
    ModelHistoryReportCardVoucher modelHistoryReportCardVoucher,
    BuildContext context) {
  return Slidable(
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 0,
                    backgroundColor: const Color(0xffF2F2F2),
                    title: TextNormalBlack("Attention!",
                        textAlign: TextAlign.center),
                    content: TextGrey(
                        "Are you sure you want to set the user status as ${modelHistoryReportCardVoucher.isPaid == 0 ? "paid" : "unpaid"}?"),
                    actions: [
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xffFF6F77))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: TextNormalBlack("No")),
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xffAAD59E))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: TextNormalBlack("Yes"))
                    ],
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: modelHistoryReportCardVoucher.isPaid == 0
                ? CardPaidStatus(padding: const EdgeInsets.all(10))
                : CardUnPaidStatus(padding: const EdgeInsets.all(10)),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    elevation: 0,
                    backgroundColor: const Color(0xffF2F2F2),
                    title: Align(
                      alignment: Alignment.center,
                      child: TextBoldBlack("Share Info"),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TextGrey("You will share the cart as image"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Card(
                            elevation: 0,
                            color: const Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextNormalBlack("Activation Code"),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Image.asset(
                                          modelHistoryReportCardVoucher
                                                      .isTouch ==
                                                  1
                                              ? "assets/images/logo_touch.png"
                                              : "assets/images/logo_alfa.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                      )
                                    ],
                                  ),
                                  TextGrey(modelHistoryReportCardVoucher
                                      .activationCode),
                                  TextNormalBlack("Expiration Date"),
                                  TextGrey(
                                      modelHistoryReportCardVoucher.expDate),
                                  TextNormalBlack("Instruction"),
                                  TextGrey(
                                      "Dial *14*${modelHistoryReportCardVoucher.activationCode}#")
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff9ECCFA)),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xffAAD59E)),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Share"))
                    ],
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                  );
                });
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: CircleAvatar(
              backgroundColor: Color(0xff243141),
              foregroundColor: Colors.white,
              child: Icon(Icons.ios_share),
            ),
          ),
        )
      ]),
      child: Card(
        color: const Color(0xffF2F2F2),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: OvalLetter(modelHistoryReportCardVoucher.name ?? "User"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextNormalBlack(
                        modelHistoryReportCardVoucher.name ?? "User"),
                  ),
                  SizedBox(
                    width: 80,
                    child: TextGrey(modelHistoryReportCardVoucher.phoneNumber),
                  )
                ],
              ),
            ),
            Expanded(
                child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              color: const Color(0xffFFFFFF),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: modelHistoryReportCardVoucher.isPaid == 0
                          ? CardUnPaidStatus()
                          : CardPaidStatus(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextNormalBlack("Activation Code"),
                        Image.asset(
                          modelHistoryReportCardVoucher.isTouch == 0
                              ? "assets/images/logo_alfa.png"
                              : "assets/images/logo_touch.png",
                          width: 30,
                          height: 30,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: TextGrey(
                          modelHistoryReportCardVoucher.activationCode),
                    ),
                    TextNormalBlack("Expiration Date"),
                    TextGrey(modelHistoryReportCardVoucher.expDate),
                    TextNormalBlack("Cart Info"),
                    TextGrey(modelHistoryReportCardVoucher.info),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextGrey(modelHistoryReportCardVoucher.date),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ));
}
