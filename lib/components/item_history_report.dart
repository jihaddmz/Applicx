import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_paid_status.dart';
import 'package:applicx/components/card_unpaid_status.dart';
import 'package:applicx/components/oval_letter.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/models/model_report.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class ItemHistoryReportGift extends StatelessWidget {
  ItemHistoryReportGift(
      {required this.modelReport,
      required this.context,
      required this.currentPhoneNumber,
      required this.onYesChangeStatusClick});

  final ModelHistoryReportGift modelReport;
  final BuildContext context;
  final String currentPhoneNumber;
  final Function(ModelHistoryReportGift, int) onYesChangeStatusClick;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: (details) => {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: const Color(0xffF2F2F2),
                title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
                content: TextGrey(
                    "Are you sure you want to set the user status as ${modelReport.isPaid == 0 ? "paid" : "unpaid"}?",
                    textAlign: TextAlign.center),
                actions: [
                  ButtonSmall("No", () {
                    Navigator.pop(context);
                  }),
                  ButtonSmall("Yes", () {
                    Navigator.pop(context);
                    // if this item is already paid, change its status to unpaid, otherwise change it to paid
                    onYesChangeStatusClick(
                        modelReport, modelReport.isPaid == 0 ? 1 : 0);
                  }, color: const Color(0xffAAD59E))
                ],
                actionsAlignment: MainAxisAlignment.spaceEvenly,
              );
            })
      },
      leftSwipeWidget:
          modelReport.isPaid == 0 ? CardPaidStatus() : CardUnPaidStatus(),
      child: Card(
        color: const Color(0xffF2F2F2),
        elevation: 4,
        surfaceTintColor: const Color(0xffF2F2F2),
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
                  OvalLetter(modelReport.name ?? "U",
                      color: currentPhoneNumber == modelReport.phoneNumber
                          ? const Color(0xffFFB1B6)
                          : const Color(0xff9ECCFA)),
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
                  child: TextGrey(modelReport.date,
                      fontSize: 13, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
