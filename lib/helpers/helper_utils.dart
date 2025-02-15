import 'dart:io';

import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:flutter_phone_dialer/flutter_phone_dialer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd_service/ussd_service.dart';

class HelperUtils {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<void> chargeCardVoucher(
      String number, String code, bool isTouch) async {
    String message = "";

    if (isTouch) {
      message = "*300*961$number*14*$code#";
    } else {
      message = "*111*3*2*$number*1*$code#";
    }
    if (Platform.isAndroid) {
      await UssdService.makeRequest(1, message, const Duration(seconds: 60));
    } else {
      // var ussdResponseMessage =
      //     await UssdAdvanced.sendAdvancedUssd(code: message, subscriptionId: -1);
      bool? res = await FlutterPhoneDialer.dialNumber(message);
      HelperLogging.logD("result is  $res");
    }
  }

  static Future<void> goToWhatsapp() async {
    {
      Uri url;
      if (Platform.isAndroid) {
        url = Uri.parse("https://wa.me/qr/QFWS7IKCAXXHD1");
      } else {
        url = Uri.parse('https://wa.me/qr/LC33BHI4P7U3O1');
      }
      if (!await launchUrl(url)) {
        throw Exception('Could not launch');
      }
    }
  }

  static Future<void> addPoints(double cost) async {
    HelperSharedPreferences.getPointsFormula().then((formula) async {
      HelperSharedPreferences.getPoints().then((value) async {
        await HelperFirebaseFirestore.updatePoints((cost *
                double.parse(formula.split(":")[1]) /
                double.parse(formula.split(":")[0]) +
            double.parse(value)));
        await HelperSharedPreferences.setPoints((cost *
                    double.parse(formula.split(":")[1]) /
                    double.parse(formula.split(":")[0]) +
                double.parse(value))
            .toString());
      });
    });
  }

  static Future<void> minusPoints(double cost) async {
    HelperSharedPreferences.getPoints().then((value) async {
      await HelperFirebaseFirestore.updatePoints(double.parse(value));
    });
  }

  static String formatPhoneNumber(String phoneNumber) {
    String textWritten = phoneNumber.replaceAll(" ", "");
      // 81909560
      String first = textWritten.substring(0, 2); // 81
      String second = textWritten.substring(2, 5); // 909
      String third = textWritten.substring(5, 8); // 560
      return "$first $second $third";
  }
}
