import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';


class ScreenTimePage extends StatefulWidget {
 //displays where timeID = ST_ID from time database
  final ScreenContents? ScreenContent;
  const ScreenTimePage ({Key? key,
    this.ScreenContent,}) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();

}

class _TimeDetailPageState extends State <ScreenTimePage> {
  late ScreenContents screenTime;
  late DateTime stopTime;
  late DateTime startTime;
  late String averageTime;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }


  //TODO: add graph display return here
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton()],
    ),

    body: Form(child: Center (
      onChangedAverageTime =

    )
    ),
  );

  Widget startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(onPrimary: Colors.green, primary: Colors.blue),
          onPressed: () {startTimer();}, child: Text('start time'),
        ),
    );
  }

    startTimer() async {
      // final db = await ScreenTimeDatabase.instance.database;
      // await db.rawInsert(
      //   'INSERT INTO Screen_Time (startTime) VALUES (${DateTime.now()})'
      final startTimer = ScreenContents(
          averageTime: averageTime,
          stopTime: stopTime,
          startTime: DateTime.now()
      );
    }

  Widget stopButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.red, primary: Colors.orange),
        onPressed: () {stopTimer();}, child: Text('Stop time'),
      ),
    );
  }
  stopTimer() async{
    // final db = await ScreenTimeDatabase.instance.database;
    // await db.rawInsert('INSERT INTO Screen_Time (stopTime) VALUES (${DateTime.now()}) );'
    final stopTimer = ScreenContents(
        averageTime: averageTime,
        stopTime: stopTime,
        startTime: DateTime.now()
    );

    await ScreenTimeDatabase.instance.createST(stopTimer);
  }
}






