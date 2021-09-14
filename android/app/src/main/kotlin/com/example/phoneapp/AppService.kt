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
//            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            manager.notify((System.currentTimeMillis() % 10000).toInt(), notificationBuilder)
            startForeground((System.currentTimeMillis() % 10000).toInt(), notificationBuilder)
            Log.v("OnService", "OnService")
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}