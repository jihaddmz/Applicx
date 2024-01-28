import 'package:flutter/material.dart';

class ModelCartVoucher {
  final bool isAlfa;
  final String title;
  final double cost;
  final int daysAvailability;
  final double dolars;
  final String imagePath;
  final Color color;
  final String instruction;
  final int availability;
  final Map<String, dynamic> map;
  bool isCardClicked = false;
  final String id;

  ModelCartVoucher(
      {required this.isAlfa,
      required this.id,
      required this.title,
      required this.cost,
      required this.daysAvailability,
      required this.availability,
      required this.dolars,
      required this.imagePath,
      required this.color,
      required this.map,
      required this.instruction});
}