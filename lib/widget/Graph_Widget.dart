import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/model/ScreenTime.dart';


class TimeGraphWidget extends StatelessWidget{
  TimeGraphWidget ({
    Key ? key,
    required this.screenContent,
    required this.index
}) :super (key: key);

  final ScreenContents screenContent;
  final int index;


  @override
  Widget build(BuildContext context) {
    ///very useful DateTime method, might use in other screen time database
    final stopTimer = DateFormat.yMMMMEEEEd().format(screenContent.stopTime);
    final startTimer = DateFormat.yMMMMEEEEd().format(screenContent.startTime);
    return Card(
      //returns the card UI, wrapping around goals displayed
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              startTimer,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              stopTimer,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



}

