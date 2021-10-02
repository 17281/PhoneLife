import 'package:flutter/material.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/Utils.dart';

class NavBar extends StatefulWidget {
  final int totalTime;
  final int totalAverageTime;
  final int? countOfCompletedGoals;
  final int? countOfUncompletedGoals;
  final int screenCount;
  NavBar({
    required this.totalTime,
    required this.totalAverageTime,
    required this.countOfCompletedGoals,
    required this.countOfUncompletedGoals,
    required this.screenCount,
  });

  @override
  State<NavBar> createState() => _NavBarState(totalTime, totalAverageTime, countOfUncompletedGoals,countOfCompletedGoals,screenCount);
}

class _NavBarState extends State<NavBar> {
  int totalTime;
  int totalAverageTime;
  int? countOfCompletedGoals;
  int? countOfUncompletedGoals;
  int screenCount;
  _NavBarState(this.totalTime, this.totalAverageTime, this.countOfUncompletedGoals, this.countOfCompletedGoals, this.screenCount);


  int hours = 0;
  int min = 0;
  int sec = 0;

  int diffH = 0;
  int diffMin = 0;
  int diffSec = 0;


  void calculateDiffTime() async {
    var x = widget.totalAverageTime/60;
    if (x <= 1) {
      //only seconds if average time is lesser than 60sec
      setState(() => diffSec = widget.totalAverageTime);
    }
    else {
      //Seconds
      var seconds = widget.totalAverageTime%60;
      setState(() => diffSec = seconds);

      //Minutes
      var z = (x%60).round();
      setState(() => diffMin = z);

      //Only hours if seconds < 3600
      var y = (x/60).round();
      if (y <= 0) {
        setState(() => diffH = 0);
      }
      else {
        //Hours
        setState(() => diffH = y%60);
      }
    }
  }

  void calculateTotalTime() async {
    var x = widget.totalTime/60;
    if (x <= 1) {
      //only seconds if average time is lesser than 60sec
      setState(() => sec = widget.totalTime);
    }
    else {
      //Seconds
      var seconds = widget.totalTime%60;
      setState(() => sec = seconds);

      //Minutes
      var z = (x%60).round();
      setState(() => min = z);

      //Only hours if seconds < 3600
      var y = (x/60).round();
      if (y <= 0) {
        setState(() => hours = 0);
      }
      else {
        //Hours
        setState(() => hours = y%60);
      }
    }
    print ('Sec = $sec Min = $min Hours = $hours');
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalTime();
    calculateDiffTime();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final _hours = twoDigits(hours);
    final _min = twoDigits(min);
    final _sec = twoDigits(sec);
    final _diffHours = twoDigits(diffH);
    final _diffMin = twoDigits(diffMin);
    final _diffSec = twoDigits(diffSec);
    return Drawer(
      child: Container (
        color: Colors.grey,
        child:
        ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            ListTile(
              title: Container(
                child: Text('User Stats', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.max ,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  SizedBox(height: 20,),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.add_alarm_outlined),
                    trailing: Text("$_hours : $_min : $_sec", style: TextStyle(fontSize: 12, color: Colors.white) ,),
                    title: Container(
                      child: Text(' Screen Time', style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                  ),
                  SizedBox(height:50,),
                  ListTile(
                    leading: Icon(Icons.add_to_home_screen),
                    trailing: Text("$_diffHours: $_diffMin : $_diffSec", style: TextStyle(fontSize: 12, color: Colors.white) ,),
                    title: Container(
                      child: Text('Average Screen Time', style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                  ),
                  SizedBox(height:50,),
                  ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    trailing: Text(widget.countOfCompletedGoals.toString(), style: TextStyle(fontSize: 12, color: Colors.white) ,),
                    title: Container(
                      child: Text('Completed Goals', style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                  ),
                  SizedBox(height:50,),
                  ListTile(
                    leading: Icon(Icons.remove_circle_outline),
                    trailing: Text(widget.countOfUncompletedGoals.toString(), style: TextStyle(fontSize: 12, color: Colors.white) ,),
                    title: Container(
                      child: Text('Uncompleted Goals', style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                  ),
                  SizedBox(height:50,),
                  ListTile(
                    leading: Icon(Icons.plus_one_rounded),
                    trailing: Text(widget.screenCount.toString(), style: TextStyle(fontSize: 12, color: Colors.white) ,),
                    title: Container(
                      child: Text('Current Screen Count', style: TextStyle(fontSize: 17, color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 30,),
          Divider(),
          SizedBox(height: 20,),
          MaterialButton(child: Text('Reset Stats',
            style: TextStyle(color: Colors.white),
          ),
            onPressed: () {
            createAlertDialog(context);
            },
            color: Colors.deepOrange,),
        ],
      ),
    ),
    );
  }

  createAlertDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('THIS WILL RESET ALL STATS'),
        content: Text('Do you still want to continue?'),
        actions: <Widget>[
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            MaterialButton(child: Text('No', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.red,
              elevation: 5.0,
            ),

            MaterialButton(child: Text('Yes', style: TextStyle(color: Colors.white),),
              onPressed: () {
                ScreenTimeDatabase.instance.deleteDB();
                UserDatabase.instance.deleteDB();
                DiffTimeDatabase.instance.deleteDB();
                Navigator.of(context).pop();
                Utils.alertSnackBar(context, 'Stats has been reset, restart app to begin');
              },
              color: Colors.green,
              elevation: 5.0,
            ),
          ],
      ),
        ],
      );
    });
  }
}
