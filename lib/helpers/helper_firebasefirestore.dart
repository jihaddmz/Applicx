import 'dart:math';

import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/helpers/helper_utils.dart';
import 'package:applicx/models/model_cart_voucher.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelperFirebaseFirestore {
  static late FirebaseFirestore firebaseFirestore;

  static Future<String> getAppVersion() async {
    String appVersion = "";
    await firebaseFirestore
        .collection("app")
        .doc("specifications")
        .get()
        .then((value) {
      appVersion = value.get("version");
    });

    return appVersion;
  }

  static Future<Map<String, dynamic>> fetchNotifications() async {
    Map<String, dynamic> list = {};
    await firebaseFirestore
        .collection("notifications")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      list = value.get("map");
    }).onError((error, stackTrace) {});

    return list;
  }

  static Future<void> setNotificationsAsCleared(
      Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection("notifications")
        .doc(await HelperSharedPreferences.getUsername())
        .set({"map": map}, SetOptions(merge: true));
  }

  static Future<String> fetchExpDate() async {
    String result = "";
    await firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      result = value.get("expDate");
    });

    return result;
  }

  static Future<void> setExpDate(String value) async {
    Map<String, String> map = {};
    map["expDate"] = value;
    await firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .set(map, SetOptions(merge: true));
  }

  static Future<double> fetchWalletAmount() async {
    String result = "";
    await firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      result = value.get("walletAmount");
    });

    return double.parse(result);
  }

  static Future<void> setWalletAmount(double value) async {
    Map<String, String> map = Map();
    map["walletAmount"] = "${value.toStringAsFixed(2)}";
    await firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .set(map, SetOptions(merge: true));
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      fetchUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>>? result;
    await firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      result = value;
    });

    return result!;
  }

  static Future<int> fetchNumberOfDevicesSignedIn(String userName) async {
    int nbOfDevices = 0;
    await firebaseFirestore
        .collection("users")
        .doc(userName)
        .get()
        .then((value) {
      nbOfDevices = value.get("nbreOfDevicesSignedIn");
    }).onError((error, stackTrace) {
      nbOfDevices = -1;
    });

    return nbOfDevices;
  }

  static Future<void> updateNumberOfDevicesSignedIn(
      String username, int number) async {
    Map<String, dynamic> map = {};

    map["nbreOfDevicesSignedIn"] = number;

    await firebaseFirestore
        .collection("users")
        .doc(username)
        .set(map, SetOptions(merge: true))
        .onError((error, stackTrace) => null)
        .then((value) => null);
  }

  static Future<void> listenForWalletAmountChanges(
      Function(double) onWalletAmountChange) async {
    firebaseFirestore
        .collection("users")
        .doc(await HelperSharedPreferences.getUsername())
        .snapshots()
        .listen((event) {
      onWalletAmountChange(double.parse(event.get("walletAmount")));
    });
  }

  static Future<void> fetchCardVouchers(
      Function(QuerySnapshot<Map<String, dynamic>>) onChange,
      bool isAlfa) async {
    firebaseFirestore
        .collection("services")
        .doc("cardVouchers")
        .collection(isAlfa ? "alfa" : "touch")
        .snapshots()
        .listen((event) {
      onChange(event);
    });
  }

  static Future<ModelCartVoucher> removeCardVoucher(
      ModelCartVoucher modelCartVoucher) async {
    Map<String, dynamic> map = Map.from(modelCartVoucher.map);

    map.remove(map.keys.elementAt(0));

    await firebaseFirestore
        .collection("services")
        .doc("cardVouchers")
        .collection(modelCartVoucher.isAlfa ? "alfa" : "touch")
        .doc(modelCartVoucher.id)
        .set({"cost": modelCartVoucher.cost.toString(), "list": map},
            SetOptions(merge: false));

    return modelCartVoucher;
  }

  static Future<void> createCardVoucherHistory(
      ModelCartVoucher modelCartVoucher,
      String username,
      String phoneNumber) async {
    Map<String, dynamic> map = {
      "username": username,
      "phoneNumber": phoneNumber,
      "actCode": modelCartVoucher.map.keys.elementAt(0),
      "expDate": modelCartVoucher.map.values.elementAt(0),
      "cartInfo":
          "${modelCartVoucher.title == "وفّر" ? "Waffer" : ""} ${modelCartVoucher.cost}\$",
      "paid": true,
      "alfa": modelCartVoucher.isAlfa,
      "date": DateTime.now().toString()
    };
    await firebaseFirestore
        .collection("servicesHistory")
        .doc("cardVouchers")
        .collection(await HelperSharedPreferences.getUsername())
        .doc("${Random().nextInt(1000000)}_${Random().nextDouble() * 10000}")
        .set(map);
  }

  static Future<void> createGiftVoucherHistory(ModelGift modelGift,
      String username, bool isAlfa, String phoneNumber) async {
    if (await HelperUtils.isConnected()) {
      Map<String, dynamic> map = {
        "username": username,
        "phoneNumber": phoneNumber,
        "service": "${modelGift.title} ${modelGift.chosen ?? ""}".trim(),
        "paid": true,
        "alfa": isAlfa,
        "date": DateTime.now().toString()
      };
      await firebaseFirestore
          .collection("servicesHistory")
          .doc("gifts")
          .collection(await HelperSharedPreferences.getUsername())
          .doc("${Random().nextInt(1000000)}_${Random().nextDouble() * 10000}")
          .set(map);
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>?> fetchHistory(
      bool isGifts) async {
    QuerySnapshot<Map<String, dynamic>>? result;
    await firebaseFirestore
        .collection("servicesHistory")
        .doc(isGifts ? "gifts" : "cardVouchers")
        .collection(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) => result = value)
        .catchError((error) {});

    return result;
  }

  static Future<void> updateHistoryItemStatus(
      int status, String docID, bool isGifts) async {
    Map<String, dynamic> map = {};
    map["paid"] = status == 0 ? false : true;
    await firebaseFirestore
        .collection("servicesHistory")
        .doc(isGifts ? "gifts" : "cardVouchers")
        .collection(await HelperSharedPreferences.getUsername())
        .doc(docID)
        .set(map, SetOptions(merge: true))
        .then((value) => null)
        .onError((error, stackTrace) => null);
  }

  static Future<List<dynamic>?> fetchPayments() async {
    List<dynamic>? result = [];

    await firebaseFirestore
        .collection("historyOfPayments")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      result = value.get("list");
    }).onError((error, stackTrace) {
      result = null;
    });

    return result;
  }

  static Future<List<dynamic>?> fetchDeposits() async {
    List<dynamic>? result = [];

    await firebaseFirestore
        .collection("historyOfDeposits")
        .doc(await HelperSharedPreferences.getUsername())
        .get()
        .then((value) {
      result = value.get("list");
    }).onError((error, stackTrace) {
      result = null;
    });

    return result;
  }
}
