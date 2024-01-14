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
}
