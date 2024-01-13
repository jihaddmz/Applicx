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
}
