import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';


class ScreenTimePage extends StatefulWidget {
 //displays where timeID = ST_ID from time database
  final int timeID;
  const ScreenTimePage ({
    Key? key,
    required this.timeID,
  }) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();

}

class _TimeDetailPageState extends State <ScreenTimePage> {
  late ScreenContents screenTime;
  late DateTime stopTime;
  late DateTime startTime;
  late String averageTime;
  late String totalTime;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    refreshTime();
  }

  Future refreshTime() async {
    setState(() => isLoading = true); {
      this.screenTime = await ScreenTimeDatabase.instance.readScreenTime(widget.ST_id);
    }
  }

  //TODO: add graph display return here
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [

        ],
      ),
    ),
  );

  Widget startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(onPrimary: Colors.green, primary: Colors.blue),
          onPressed: (){startTimer(startTime);}, child: Text('start time'),
        ),
    );
  }

    startTimer(startTime) async {
    final db = await ScreenTimeDatabase.instance.database;
     final time = await startTime.rawInsert(
     'INSERT INTO ScreenTimeTable (startTime) VALUES (',DateTime.now(),'');

  }
}






