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
  late int number;
  late String title;
  late String description;

}
