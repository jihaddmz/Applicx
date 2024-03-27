package com.appsfourlife.applicx

import android.Manifest
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.telephony.SmsManager
import android.telephony.SubscriptionInfo
import android.telephony.SubscriptionManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL  = "sendSmss"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
             // This method is invoked on the main thread.

             if (call.method == "sendSmsIn") {
                result.success(sendSmsIn(phoneNumber = call.argument<Any>("phoneNumber").toString(), msg = call.argument<Any>("msg").toString()))
             }
         }
    }

    fun sendSmsIn(phoneNumber: String, msg: String): String {
        val intent = Intent(Intent.ACTION_SENDTO)
        intent.data = Uri.parse("smsto:$phoneNumber")
        intent.putExtra("sms_body", msg)
        intent.putExtra(Intent.EXTRA_TEXT, "")
        intent.putExtra("exit_on_sent", true);
        activity?.startActivityForResult(intent, 1)

        return "success"
    }

    fun sendSms(phoneNumber: String, smsContent: String) {
        Log.d("Applicx", "sendSms: carrier is -1")

        var localSubscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager;

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
            Log.d("Applicx", "sendSms: carrier is 1")

            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        if (localSubscriptionManager.activeSubscriptionInfoCount > 1) {
            var localList = localSubscriptionManager.activeSubscriptionInfoList
            var simInfo = localList[0] as SubscriptionInfo


            Log.d("Applicx", "sendSms: carrier is 2 ${simInfo.carrierName}")


            SmsManager.getSmsManagerForSubscriptionId(simInfo.subscriptionId).sendTextMessage(phoneNumber, null, smsContent, null, null);
        } else {
            var localList = localSubscriptionManager.activeSubscriptionInfoList;
            var simInfo = localList[0] as SubscriptionInfo

            var sms = SmsManager.getDefault()

            Log.d("Applicx", "sendSms: carrier is 3 ${simInfo.carrierName}")


            SmsManager.getSmsManagerForSubscriptionId(simInfo.subscriptionId).sendTextMessage(phoneNumber, null, smsContent, PendingIntent.getBroadcast(this, 0, Intent("SMS_SENT"), PendingIntent.FLAG_IMMUTABLE), null);
        }
    }
}
