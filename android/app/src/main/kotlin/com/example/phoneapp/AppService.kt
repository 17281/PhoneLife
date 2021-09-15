package com.example.phoneapp

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat


class AppService: Service() {
    override fun onCreate() {
        super.onCreate()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationBuilder = NotificationCompat.Builder(this, "message")
                .setContentText("app is running in background")
                .setContentTitle("Background Service")
                .setSmallIcon(R.drawable.ic_andriod_black_24dp)
                .build()

            Log.v("OnService", "OnService")
            startForeground((System.currentTimeMillis() % 10000).toInt(), notificationBuilder)
            Log.v("OnService", "OnService")

        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startService()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun startService()
    {
        Thread {
            for (num in 0..50) {
                Log.v("OnCalling", ""+num)
                Thread.sleep(1000)
            }
        }.start()
    }
}