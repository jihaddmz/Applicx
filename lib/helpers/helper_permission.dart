import 'package:applicx/helpers/helper_dialog.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperPermission {
  static Future<bool> requestContactPermission(BuildContext context) async {
    var contactStatus = await Permission.contacts.request();

    if (contactStatus.isGranted) {
      // Permission granted. You can now use the camera.
      return true;
    } else if (contactStatus.isDenied) {
      if (context.mounted) {
        HelperDialog.showDialogInfo(
            "Attention!",
            "In order to be able to choose a contact on your phone, you have to grant this permission",
            context, () {
          requestContactPermission(context);
        });
      }
      // Permission denied. You might want to show a message to the user.
    } else if (contactStatus.isPermanentlyDenied) {
      if (context.mounted) {
        HelperDialog.showDialogInfo(
            "Attention!",
            "In order to be able to choose a contact on your phone, you have to grant this permission",
            context, () {
          openAppSettings();
        });
      }
      // The user has permanently denied the permission.
      // You might want to guide the user to the app settings.
    }
    return false;
  }
}
