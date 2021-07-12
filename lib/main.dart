import 'package:flutter/material.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:flutter/services.dart';
import 'package:phoneapp/page/content_page.dart';

///UI of my database
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
  static final String title = 'User SQLite';
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme of app is dark
    themeMode: ThemeMode.dark,
    theme: ThemeData(
      //colors of theme
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    //place in data from content page
    home: ContentPage(),
  );
}