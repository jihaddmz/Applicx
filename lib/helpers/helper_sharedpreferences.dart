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

  static Future<int> getNbreOfDevicesSignedIn() async {
    return instance.getInt("nbreOfDevicesSignedIn") ?? 0;
  }

  static Future<void> setNbreOfDevicesSignedIn(int value) async {
    await instance.setInt("nbreOfDevicesSignedIn", value);
  }

  static Future<double> getSubscriptionFees() async {
    return instance.getDouble("subscriptionFees") ?? 0;
  }

  static Future<void> setSubscriptionFees(double value) async {
     await instance.setDouble("subscriptionFees", value);
  }

  static Future<bool> isActive() async {
    return instance.getBool("isActive") ?? true;
  }

  static Future<void> setIsActive(bool value) async {
    await instance.setBool("isActive", value);
  }

  static Future<String> getExpDate() async {
    return instance.getString("expDate") ?? "";
  }

  static Future<void> setExpDate(String value) async {
    await instance.setString("expDate", value);
  }

  static Future<String> getAddress() async {
    return instance.getString("address") ?? "";
  }

  static Future<void> setAddress(String value) async {
    await instance.setString("address", value);
  }

  static Future<double> getWalletAmount() async {
    return instance.getDouble("walletAmount") ?? 0;
  }

  static Future<void> setWalletAmount(double value) async {
    await instance.setDouble("walletAmount", value);
  }

  static Future<void> clearSharedPreferences() async {
    instance.clear();
  }
}
