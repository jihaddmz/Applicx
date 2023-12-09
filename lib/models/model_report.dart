class ModelHistoryReportGift {
  String? name;
  final String phoneNumber;
  final String service;
  final String date;
  final int isTouch;
  final int isPaid;

  ModelHistoryReportGift(
      {this.name,
      required this.phoneNumber,
      required this.service,
      required this.date,
      required this.isTouch,
      required this.isPaid});
}
