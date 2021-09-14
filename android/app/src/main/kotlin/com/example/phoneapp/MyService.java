package com.example.phoneapp;

import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

public class MyService extends Service {


    @Override
    public void onCreate() {
        super.onCreate();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationManager manager = getSystemService(NotificationManager.class);
            NotificationCompat.Builder builder = new NotificationCompat.Builder
                    (this, "messages")
                    .setContentText("this is running in the back")
                    .setContentTitle("Flutter Background")
                    .setSmallIcon(R.drawable.ic_andriod_black_24dp);
        }
    }
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
