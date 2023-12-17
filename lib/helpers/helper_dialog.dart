import 'package:applicx/components/button.dart';
import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

class HelperDialog {
  static void showDialogInfo(
      String title, String msg, BuildContext context, Function() onClick) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextBoldBlack(title),
            content: TextNormalBlack(msg),
            actions: [
              ButtonSmall("OK", () {
                Navigator.pop(context);
                onClick();
              })
            ],
          );
        });
  }
}
