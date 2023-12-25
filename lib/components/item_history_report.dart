import 'package:applicx/components/card_paid_status.dart';
import 'package:applicx/components/card_unpaid_status.dart';
import 'package:applicx/components/oval_letter.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_report.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

Widget ItemHistoryReportGift(
    ModelHistoryReportGift modelReport, BuildContext context) {
  return SwipeTo(
    onLeftSwipe: (details) => {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 0,
              backgroundColor: const Color(0xffF2F2F2),
              title: TextNormalBlack("Attention!", textAlign: TextAlign.center),
              content: TextGrey(
                  "Are you sure you want to set the user status as ${modelReport.isPaid == 0 ? "paid" : "unpaid"}?"),
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
          })
    },
    leftSwipeWidget:
        modelReport.isPaid == 0 ? CardPaidStatus() : CardUnPaidStatus(),
    child: Card(
      color: const Color(0xffF2F2F2),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: modelReport.isPaid == 1
                  ? CardPaidStatus()
                  : CardUnPaidStatus(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                OvalLetter(modelReport.name ?? "U"),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextNormalBlack(modelReport.name ?? "User"),
                      ),
                      TextGrey(modelReport.phoneNumber)
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextGrey(modelReport.service),
                ),
                Image.asset(
                    width: 30,
                    height: 30,
                    modelReport.isTouch == 0
                        ? "assets/images/logo_alfa.png"
                        : "assets/images/logo_touch.png"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
              child: Container(
                alignment: Alignment.bottomRight,
                child: TextGrey(modelReport.date),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
