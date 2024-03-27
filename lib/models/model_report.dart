class ModelHistoryReportGift {
  String id;
  String? name;
  final String phoneNumber;
  final String service;
  final String date;
  final int isTouch;
  int isPaid;

  ModelHistoryReportGift(
      {required this.id, this.name,
      required this.phoneNumber,
      required this.service,
      required this.date,
      required this.isTouch,
      required this.isPaid});
}
