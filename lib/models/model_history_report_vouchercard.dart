class ModelHistoryReportCardVoucher {
  String id;
  String? name;
  final String phoneNumber;
  final String activationCode;
  final String expDate;
  final String info;
  final String date;
   int isPaid; // 0 for unpaid and 1 for paid
  final int isTouch; // 0 for alfa and 1 for touch

  ModelHistoryReportCardVoucher(
      {required this.id, this.name,
      required this.phoneNumber,
      required this.activationCode,
      required this.expDate,
      required this.info,
      required this.date,
      required this.isPaid,
      required this.isTouch});
}
