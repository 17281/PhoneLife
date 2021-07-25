import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ScreenTimePage extends StatefulWidget {
 //displays where timeID = ST_ID from time database
  final int timeID;

  //TODO: Added timeID: ST_ID in content page
  const ScreenTimePage ({
    Key? key,
    required this.timeID,
  }) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();

}

class _TimeDetailPageState extends State <ScreenTimePage> {
  late ScreenContents screenTime;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    refreshTime();
  }

  Future refreshTime() async {
    setState(() => isLoading = true); {
      this.screenTime = await ScreenTimeDatabase.instance.readScreenTime(widget.ST_id)
    }
  }

  @override
  Widget build(BuildContext context) {

  }

}
