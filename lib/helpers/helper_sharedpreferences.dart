import 'package:shared_preferences/shared_preferences.dart';

class HelperSharedPreferences {
  static late SharedPreferences instance;

  static Future<String> getUsername() async {
    return instance.getString("username") ?? "";
  }

  static Future<void> setUsername(String value) async {
    await instance.setString("username", value);
  }

  static Future<String> getPhoneNumber() async {
    return instance.getString("phonenumber") ?? "";
  }

  static Future<void> setPhoneNumber(String value) async {
    await instance.setString("phonenumber", value);
  }

  static Future<String> getAddress() async {
    return instance.getString("address") ?? "";
  }

  static Future<void> setAddress(String value) async {
    await instance.setString("address", value);
  }

  static Future<double> getWalletAmount() async {
    return instance.getDouble("walletAmount") ?? 20;
  }

  static Future<void> setWalletAmount(double value) async {
    await instance.setDouble("walletAmount", value);
  }

  static Future<void> clearSharedPreferences() async {
    instance.clear();
  }
}
