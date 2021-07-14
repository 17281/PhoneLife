import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';

class GoalCardWidget extends StatelessWidget {
  GoalCardWidget({
    Key? key,
    required this.goal,
    required this.index,
  }) : super(key: key);

  final UserContent goal;
  final int index;

  @override
  Widget build(BuildContext context) {
    ///very useful DateTime method, might use in other screen time database
    final time = DateFormat.yMMMd().format(goal.createdTime);
    return Card(
      //returns the card UI, wrapping around goals displayed
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              goal.name,
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