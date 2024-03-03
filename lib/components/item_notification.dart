import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_notification.dart';
import 'package:flutter/material.dart';

Widget ItemNotification(BuildContext context,
    ModelNotification modelNotification, Color circleColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Card(
        color: circleColor,
        shape: const OvalBorder(side: BorderSide.none),
        child: const Padding(padding: EdgeInsets.all(5)),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
            elevation: 4,
            surfaceTintColor: const Color(0xffF2F2F2),
            color: const Color(0xffF2F2F2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.6,
                    margin: const EdgeInsets.fromLTRB(0, 20, 5, 20),
                    child: TextNormalBlack(modelNotification.message),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.3,
                    child: TextGrey(modelNotification.date.split(" ")[0]),
                  )
                ],
              );
            })),
      )
    ],
  );
}
