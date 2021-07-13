import 'package:phoneapp/db/User_database.dart';
import 'package:flutter/material.dart';
import 'package:phoneapp/model/Goals.dart';

class AddEditGoalPage extends StatefulWidget {
  final UserContent? goal;
  const AddEditGoalPage({Key? key, this.goal}) : super(key: key);
  @override
  _AddEditGoalPageState createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage>{
  //creates a validation method for when users insert data into database
  final _formkey = GlobalKey<FormState>();
  late bool isImportant;
  late DateTime createdTime;
  late String name;
  late String description;

  //initiate database and conversions.
  @override
  void initState() {
    super.initState();
    //setting isImportant factor to false when created
    isImportant = widget.goal?.isImportant ?? false;
    //chang-able '' field
    name = widget.goal?.name ?? '';
    description = widget.goal?.description ?? '';
  }

  //build the editing widget
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      //input action - TODO: create simple sliding goal setting system
      actions: [],
    ),
    body: Form(
      key: _formkey, child: (isImportant),
    ),
  );

}
