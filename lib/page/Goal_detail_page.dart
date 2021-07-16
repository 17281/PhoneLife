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
}