import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Time_Detail_page.dart';
import '../Utils.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/page/Screen_Time_Page.dart';
import 'package:phoneapp/widget/Graph_Widget.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';


class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

//the state of content page remains as a stateful widget
class _ContentPageState extends State<ContentPage> {


  // final int currentGoalID;
  int goalIndex = 2;
  int? completedNum = 0;
  int? unCompletedNum = 0;

  int averageSec = 0;
  num hours = 0;
  num min = 0;
  num sec = 0;

  void calculate() async {
    int testTime = 80;
    var x = testTime/60;
    if (x < 1) {
      setState(() => sec = testTime);
      print('seconds is = $sec');
    }
    else {
    }
    print ('X is = $x');
  }

  static List<String> goalValues = [
    'No Phone?!?!',
    'Living the life',
    'The Average Joe',
    'Easy Life',
    'Baby Mode',
  ];


  late UserContent goal;

  //Initiation of Goal Table variables
  late DateTime createdTime;
  late int goalTime;
  late bool isCompleted;

  //finds all 'goals' from userTable
  late List<UserContent> goals;
  //finds all screen time value
  late List<ScreenContents> screenContent;
  bool isLoading = false;
  late int currentGoalId;

  //refresh database when ever updated
  @override
  void initState() {
    super.initState();
    //refresh future content per update (Useful fo updating goals)
    refreshGoals();
    refreshScreenTime();
  }

  //closing database when app is down
  @override
  void dispose() {
    //closes db
    UserDatabase.instance.closeDB();
    ScreenTimeDatabase.instance.closeSTDB();
    super.dispose();
  }

  //Updating goal
  Future refreshGoal() async {
    setState(() => isLoading = true);
    this.goal = await UserDatabase.instance.readGoal(currentGoalId);
    setState(() => isLoading = false);
  }

//Updating screen time data displayed
  Future refreshScreenTime() async {
    //sets database to be async loading to the pag
    setState(() => isLoading = true);{
      //refresh and display new data on page
      this.screenContent = await ScreenTimeDatabase.instance.readAllTime();
      //after database loads, change the loading symbol to off
      setState(() => isLoading = false);
      final avg = screenContent.map((m) => (m.diffTime)).reduce((a, b) => a + b)/screenContent.length;
      setState(() => averageSec = avg.round());
      print ('The average seconds: $averageSec');
      calculate();
    }
  }

  //updates content when ever new content added
  Future refreshGoals() async {
    //when loading database
    setState(() => isLoading = true);
    //refreshes all goals when new data added
    this.goals = await UserDatabase.instance.readAllGoals();
    setState(() => isLoading = false);
  }


  Future updateGoal() async {
    currentGoalId = UserDatabase.goalID;
    refreshGoal();
    isCompleted = true;
  final currentGoal = goal.copy(
    isCompleted: isCompleted
  );
    await UserDatabase.instance.update(currentGoal);
    print('Goal is update');
  }

  Future addGoal() async {
    //add all the content from the fields into a single statement
    final goalA = UserContent(
      goalTime: goalTime,
      isCompleted: false,
      createdTime: DateTime.now(),
    );
    await UserDatabase.instance.create(goalA);
    Timer(Duration(seconds: 10), () {
      updateGoal();
      numOfCompleted();
      numOfUnCompleted();
    });
  }


  void numOfCompleted() async {
    int? countC = await UserDatabase.instance.countCompletedGoals();
    setState(() => completedNum = countC);
  }

  void numOfUnCompleted() async {
    int? countUC = await UserDatabase.instance.countUnCompletedGoals();
    setState(() => unCompletedNum = countUC);
  }


  @override
  ///Main Page display
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Number of completed goals: $completedNum'),
        ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,

        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
              ElevatedButton(onPressed: () async {
                //parseDuration();
                   await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScreenTimePage()));
                   //Once created refresh goals display page
                  refreshScreenTime();
                  refreshGoals();},
                  child: Icon(Icons.atm),
              ),

                Container(
                  child: Text(''),
                ),

        ]
    ),
      alignment: Alignment.centerRight,
    ),

          Container(
            height: 200,
            width: 250,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  ElevatedButton(
                      onPressed: () async {
                        Utils.showSheet(context,
                          child: buildPicker(),
                          onClicked: () {final goalValue = goalValues[goalIndex];
                          Utils.showSnackBar(context, '"$goalValue" has been selected, Survive the day without using your phone over $goalIndex hours');
                          Navigator.pop(context);});
                        setState(() {
                          goalTime = goalIndex;
                          this.createdTime = DateTime.now();
                        });
                        addGoal();
                      },

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.all(0.0),
                    ),
                    child:Ink (
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xff64B6FF), Color(0xff374ABE)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 300.0, maxHeight: 40),
                        alignment: Alignment.center,
                        child: Text('Use your phone under $goalIndex hours', style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    ),
                  ),
                  ),
                  // SizedBox(height: 20),
                ]
            ),
          ),
          Container(
            height: 200,
            child: SfCircularChart(
              series: <CircularSeries>[
                DoughnutSeries<GoalCompletionData, String>(
                  dataSource: getChartData(),
                  xValueMapper: (GoalCompletionData data, _) => data.name,
                  yValueMapper: (GoalCompletionData data, _) => data.isComplete,
                  dataLabelSettings: DataLabelSettings (isVisible: true)
                )
              ],
            ),

          ),
        ]
    ),
    );
  }

  Widget buildPicker() => SizedBox(
    height: 200,
    child: CupertinoPicker(
      itemExtent: 64,
      diameterRatio: 0.7,
      onSelectedItemChanged: (goalIndex) => setState(() => this.goalIndex = goalIndex),
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay (
        background: Colors.pink.withOpacity(0.1),
      ),
      children: Utils.modelBuilder<String> (
        goalValues, (goalIndex, goalValues) {
          final selValue = this.goalIndex == goalIndex;
          final color = selValue ? Colors.pinkAccent:Colors.black;
          return Center(
            child: Text(
              goalValues, style: TextStyle (color: color, fontSize: 24),
            ),
          );
          },
      ),
    ),
  );

  List<GoalCompletionData> getChartData() {
    final List<GoalCompletionData> chartData = [
      GoalCompletionData(completedNum, 'Completed'),
      GoalCompletionData(unCompletedNum, 'Not Completed')
    ];
    return chartData;
  }
}


class GoalCompletionData {
  GoalCompletionData (this.isComplete, this.name);
  //the data of if a goal is completed or not
  final int? isComplete;
  final String name;
}


