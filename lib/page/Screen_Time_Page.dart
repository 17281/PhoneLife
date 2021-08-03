import 'package:intl/intl.dart';
import 'package:phoneapp/widget/Time_Form_Widget.dart';
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
  late ScreenContents screenTime;
  late String averageTime;
  late DateTime stopTime;
  late DateTime startTime;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    averageTime = widget.screenContent?.averageTime ?? '';
  }


  //TODO: add graph display return here
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton(), submitButton()],
    ),

    body: Form(
      child: TimeFormWidget (
        onChangedAverageTime: (averageTime) => setState(() => this.averageTime = averageTime)
      )
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
    final finalTime = ScreenContents(
      averageTime: averageTime,
      stopTime: stopTime,
      startTime: startTime,
    );
    await ScreenTimeDatabase.instance.createST(finalTime);
  }
}






