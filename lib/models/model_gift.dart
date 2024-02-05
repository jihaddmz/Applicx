import 'package:flutter/material.dart';

class ModelGift {
  final int isServiceCreditTransfer; // 1 for true 0 for false
  final String title;
  final String msg;
  double? totalFees;
  final String? availability;
  double? cost;
  double transfeerFees;
  final Color? color;
  final List<String>? listOfOptions;
  String? chosen;
  bool showConfirm;

  ModelGift(
      {required this.isServiceCreditTransfer,
      required this.title,
      required this.msg,
      this.transfeerFees = 0.0,
      this.showConfirm = false,
      this.totalFees,
      this.availability,
      this.cost,
      this.color,
      this.listOfOptions,
      this.chosen});
}
