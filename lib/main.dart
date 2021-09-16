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

class AppRetainingWidget extends StatelessWidget {
  const AppRetainingWidget({Key? key,  required this.child}) : super(key: key);

  final Widget child;
  final retainChannel = const MethodChannel("com.example/retainApp");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: child, onWillPop: () async {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return true;
          } else {
            retainChannel.invokeMethod("sendToBackground");
            return false;
          }
        }else {return true; }

      }
    );
  }
}