package com.example.phoneapp

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger,"com.example.phoneapp")
            .setMethodCallHandler{call,_->
                if(call.method=="startService")
                {
                    startService()
                }
            }

    }
    private lateinit var intent:Any

    private fun startService()
    {
        intent=Intent(this,AppService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent as Intent)
        }else
        {
            startService(intent as Intent)
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        stopService(intent as Intent)
    }
}
