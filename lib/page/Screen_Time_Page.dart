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
  late String diffTime;
  late DateTime stopTime;
  late DateTime startTime;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }


  //TODO: add graph display return here
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton(), submitButton()],
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
        onPressed: () async {stopTime = DateTime.now();}, child: Text('Stop time'),
      ),
    );
  }

  Widget submitButton() {
    return Padding (
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton (
        style: ElevatedButton.styleFrom( onPrimary: Colors.red, primary: Colors.blueAccent),
        onPressed: () {submit();}, child: Text('Submit'),
        ),
      );
  }

  submit()async {
    Duration difference = stopTime.difference(startTime);

     String diffTime = difference.toString();
    print (difference);
    final finalTime = ScreenContents(
      stopTime: stopTime,
      startTime: startTime,
      diffTime: diffTime,
    );
    parseDuration(diffTime);
    await ScreenTimeDatabase.instance.createST(finalTime);

  }


  Duration parseDuration(String s)
  {
    int hours = 0;
    int minutes = 0;
    int sec = 0;
    final splitTime = s.split(':');
    print (splitTime);
    if (splitTime.length > 2) {
      hours = int.parse(splitTime[splitTime.length - 3]);
    }
    if (splitTime.length > 1) {
      minutes = int.parse(splitTime[splitTime.length - 2]);
    }
    sec = (int.parse(splitTime[splitTime.length - 1]).round());

    return Duration(hours: hours, minutes: minutes, seconds: sec);
  }

}






