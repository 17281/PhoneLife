import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';


class TimeDetailPage extends StatefulWidget {
  //displays where timeID = ST_ID from time database

  final int timeID;
  const TimeDetailPage ({Key? key,
    required this.timeID}) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();
}

class _TimeDetailPageState extends State <TimeDetailPage> {
  late ScreenContents screenTime;
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
    appBar: AppBar ( actions:[deleteButton()]),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
      ),
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await UserDatabase.instance.delete(widget.timeID);
      Navigator.of(context).pop();
    },
  );
}
