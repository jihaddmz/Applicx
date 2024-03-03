import 'dart:io';

import 'package:applicx/helpers/helper_logging.dart';
import 'package:flutter_phone_dialer/flutter_phone_dialer.dart';
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
      await UssdService.makeRequest(
          1, message, const Duration(seconds: 60));
    } else {
      // var ussdResponseMessage =
      //     await UssdAdvanced.sendAdvancedUssd(code: message, subscriptionId: -1);
      bool? res = await FlutterPhoneDialer.dialNumber(message);
      HelperLogging.logD("result is  $res");
    }
  }
}
