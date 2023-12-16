import 'package:flutter/material.dart';

class ModelCartVoucher {
  final bool isAlfa;
  final String title;
  final double cost;
  final int availability;
  final double dolars;
  final String imagePath;
  final Color color;
  final String actCode;
  final String expDate;
  final String instruction;
  bool isCardClicked = false;

  ModelCartVoucher(
      {required this.isAlfa,
      required this.title,
      required this.cost,
      required this.availability,
      required this.dolars,
      required this.imagePath,
      required this.color,
      required this.actCode,
      required this.expDate,
      required this.instruction});
}
