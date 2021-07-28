import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/model/ScreenTime.dart';


class TimeGraphWidget extends StatelessWidget{
  TimeGraphWidget ({
    Key ? key,
    required this.screenTime,
    required this.index
}) :super (key: key);

  final ScreenContents screenTime;
  final int index;

}