package com.example.app

import android.provider.Telephony
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity(){
    private lateinit var methodChannelResult: MethodChannel.Result
    private var list = mutableListOf<String>()

    private var requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) {
        isGranted->
        if(isGranted){
            readSms()
        } else {
            Toast.makeText(this, "Permission not granted", Toast. LENGTH_LONG).show()
        }
    }


    private fun readSms() {
        val cursor = contentResolver.query(
            Telephony.Sms.CONTENT_URI,
            null,
            null,
            null,
            null
        )
        if (cursor != null && cursor.moveToFirst()) {
            do{
                val address = cursor.getString(cursor.getColumnIndexOrThrow(Telephony.Sms.ADDRESS))
                val body = cursor.getString(cursor.getColumnIndexOrThrow(Telephony.Sms.BODY))
                list.add("Sender: $address\nMessage: $body")
            } while(cursor.moveToNext())
        }
        cursor?.close()
        methodChannelResult.success(list)
        list.clear()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "smsPlatform"
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result
            when(call.method) {
                "readAllSms" -> {
                    requestPermissionLauncher.launch(android.Manifest.permission.READ_SMS)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
