import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Edit_Goals.dart';


class GoalDetailPage extends StatefulWidget {
  //the goal ID returned has to be INT
  ///display goals where goalID = ?
  final int goalID;

  const GoalDetailPage ({
    Key? key,
    required this.goalID,
}) :super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();

}

//Starts the UI page/makes a new detail page
class _GoalDetailPageState extends State<GoalDetailPage> {
  late UserContent goal;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  //refreshes content
  Future refreshNote() async {
    setState(() => isLoading = true);
    this.goal = await UserDatabase.instance.readGoal(widget.goalID);
    setState(() => isLoading = false);
  }


}