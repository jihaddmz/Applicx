import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
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
    Map<String, String> map = Map();
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
    HelperLogging.logD("wallet2 $value");
    map["walletAmount"] = "$value";
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
}
