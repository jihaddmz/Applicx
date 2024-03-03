import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_buy_credit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget ItemBuyCredit(ModelBuyCredit modelBuyCredit, int tabIndex,
    Function(ModelBuyCredit) onClick) {
  return SizedBox(
    width: double.maxFinite,
    height: 170,
    child: Card(
      color: const Color(0xffF2F2F2),
      elevation: 4,
      surfaceTintColor: const Color(0xffF2F2F2),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  onClick(modelBuyCredit);
                },
                child: SvgPicture.asset(
                  "assets/svgs/vector_circleforward.svg",
                  width: 50,
                  height: 50,
                ),
              )),
          Row(
            children: [
              SizedBox(
                height: 170,
                width: 20,
                child: Card(
                  color: Color(tabIndex == 0 ? 0xffFF6F77 : 0xff009CBC),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextNormalBlack(
                        "${tabIndex == 0 ? "Alfa" : "Touch"} ${modelBuyCredit.credits}\$ Credit"),
                    TextGrey(
                        "Recharge ${modelBuyCredit.credits}\$ ${tabIndex == 0 ? "alfa" : "touch"} credit"),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child:
                          TextNormalBlack("Price: ${modelBuyCredit.cost} \$"),
                    ),
                    TextNormalBlack("Message Fees: ${modelBuyCredit.fees} \$"),
                    TextNormalBlack(
                        "Total Cost: ${(modelBuyCredit.fees + modelBuyCredit.cost).toStringAsFixed(2)} \$"),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
