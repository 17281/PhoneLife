import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phoneapp/page/content_page.dart';

Future main() async {
  //initiates widget
  WidgetsFlutterBinding.ensureInitialized();
  //displaying tables and data
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

Future startService()
async {
  if(Platform.isAndroid)
  {
    var methodChannel=MethodChannel("com.example.messages");
    String data=await methodChannel.invokeMethod("startService");
    debugPrint(data);

  }
}

class MyApp extends StatelessWidget {
  static final String title = 'User';
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme of app is dark
    themeMode: ThemeMode.dark,
    theme: ThemeData(
      //colors of theme
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.grey,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    //place in data from content page
    home: ContentPage(),

  );
}