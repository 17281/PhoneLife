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

  //Building UI
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      ///Action Key for editing or deleting data
      //TODO: use the edit button function to change it so that it's a slideable
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: EdgeInsets.all(12),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            goal.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            DateFormat.yMMMMd().format(goal.createdTime),
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    ),
  );
  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditGoalPage(goal: goal),
        ));
//refresh page when new data added
        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await UserDatabase.instance.delete(widget.goalID);
      Navigator.of(context).pop();
    },
  );
}

