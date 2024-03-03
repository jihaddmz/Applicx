import 'package:applicx/components/button.dart';
import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

class HelperDialog {
  static void showDialogInfo(
      String title, String msg, BuildContext context, Function() onClick) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            title: TextBoldBlack(title, textAlign: TextAlign.center),
            content: TextNormalBlack(msg, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ButtonSmall("OK", () {
                Navigator.pop(context);
                onClick();
              })
            ],
          );
        });
  }

  static void showLoadingDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            title: TextBoldBlack(msg),
            content: const CircularProgressIndicator(
              color: Color(0xff243141),
            ),
          );
        });
  }

  static void showDialogNotConnectedToInternet(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            title: TextBoldBlack("Attention!", textAlign: TextAlign.center),
            content: TextGrey(
                "You don't have network access, pls connect and try again!",
                textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ButtonSmall("Ok", () {
                Navigator.pop(context);
              })
            ],
          );
        });
  }
}
