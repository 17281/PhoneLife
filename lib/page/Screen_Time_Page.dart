import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';
import 'package:phoneapp/model/ScreenTime.dart';



class ScreenTimePage extends StatefulWidget {
 //displays where timeID = ST_ID from time database
  final ScreenContents? ScreenContent;
  const ScreenTimePage ({Key? key, this.ScreenContent,}) :super(key: key);

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
      this.screenTime = await ScreenTimeDatabase.instance.readScreenTime(widget.timeID);
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

          Text(
            DateFormat.yMMMMEEEEd().format(screenTime.startTime),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),

          Text(
            DateFormat.yMMMMEEEEd().format(screenTime.stopTime),
            style: TextStyle(
                color: Colors.black,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 8),


        ], //Children
      ),
    ),
  );

  Widget startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(onPrimary: Colors.green, primary: Colors.blue),
          onPressed: startTimer(), child: Text('start time'),
        ),
    );
  }

    startTimer() async {
      final db = await ScreenTimeDatabase.instance.database;
      await db.rawInsert(
        'INSERT INTO Screen_Time (startTime) VALUES (${DateTime.now()})'

      );


    }
  Widget stopButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.red, primary: Colors.orange),
        onPressed: stopTimer(), child: Text('Stop time'),
      ),
    );
  }
  stopTimer() async{
    final db = await ScreenTimeDatabase.instance.database;
    await db.rawInsert('INSERT INTO Screen_Time (startTime) VALUES (${DateTime.now()})'

    );
  }
}






