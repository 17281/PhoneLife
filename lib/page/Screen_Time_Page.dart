import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';


class ScreenTimePage extends StatefulWidget {
  //displays where timeID = ST_ID from time database
  final ScreenContents? screenContent;
  const ScreenTimePage ({Key? key,
    this.screenContent,}) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();

}

class _TimeDetailPageState extends State <ScreenTimePage> {
  late String createdTime;
  late DateTime stopTime;
  late DateTime startTime;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton()],
    ),
    body: Center(
    ),
  );

  Widget startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.green, primary: Colors.blue),
        onPressed: () async {startTime = DateTime.now();}, child: Text('start time'),
      ),
    );
  }

  Widget stopButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.red, primary: Colors.orange),
        onPressed: () async {
          stopTime = DateTime.now();
          submit();
        }, child: Text('Stop time'),
      ),
    );
  }


  submit()async {
    //Duration between initial time to final time
    Duration difference = stopTime.difference(startTime);
    final diffTime = difference.inSeconds;
    print(diffTime);
    createdTime = DateFormat.yMd().format(DateTime.now());
    final finalTime = ScreenContents(
        stopTime: DateTime.now(),
        startTime: startTime,
        diffTime: diffTime,
        createdTime: createdTime
    );
    await ScreenTimeDatabase.instance.createST(finalTime);
  }
}






