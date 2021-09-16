import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:rxdart/rxdart.dart';
import '../Utils.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/page/Screen_Time_Page.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:phoneapp/model/DiffTime.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

}

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

//the state of content page remains as a stateful widget
class _ContentPageState extends State<ContentPage> with WidgetsBindingObserver{
  //counting the amount of time phone is opened
  int screenCounter = 0;
  bool isStartService = false;

  // final int currentGoalID;
  int goalIndex = 2;
  int index = 0;
  int? completedNum = 0;
  int? unCompletedNum = 0;
  int? percentageC = 0;
  int? percentageUC= 0;

  //Calculate the total time per day
  num hours = 0;
  num min = 0;
  num sec = 0;

  //average difference
  num diffH = 0;
  num diffMin = 0;
  num diffSec = 0;

  int averageSec = 0;
  int totalSec = 0;


  void calculateDiffTime() async {
    var x = averageSec/60;
    if (x <= 1) {
      //only seconds if average time is lesser than 60sec
      setState(() => diffSec = averageSec);
    }
    else {
      //Seconds
      var seconds = averageSec%60;
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
    print ('diffSeconds = $diffSec diffMinutes = $diffMin diffHours = $diffH');
  }

  void calculateTotalTime() async {
    var x = finalTime/60;
    if (x <= 1) {
      //only seconds if average time is lesser than 60sec
      setState(() => sec = finalTime);
    }
    else {
      //Seconds
      var seconds = finalTime%60;
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

  static List<String> goalValues = [
    'No Phone?!?!',
    'Living the life',
    'The Average Joe',
    'Easy Life',
    'Baby Mode',
  ];
  static List<String> values = [
  '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15'];

  late GoalContent? diffGoal;
  late UserContent? goal;
  //Initiation of Goal Table variables
  late DateTime createdTime;
  late int goalTime;
  late int diffGoalTime;

  //finds all 'goals' from userTable
  late List<UserContent> goals;
  //finds all diffGoals from diffTimeTable
  late List<GoalContent> diffGoals;
  //finds all screen time value
  late List<ScreenContents> screenContent;
  //final all 'time data' from screen time table
  late final ScreenContents? screenContents;
  bool isLoading = false;

  //goalID
  late int currentGoalId;
  late int currentDiffGoalId;
  late int finalTime;
  //stop time function
  late Timer _timer;
  late Timer _diffTimer;

  //Screen time variables
  late DateTime startTime;
  late String timeStamp;
  late DateTime stopTime;

  String formatDuration(Duration timerDuration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = (timerDuration.inMinutes.remainder(60));
    final seconds = (timerDuration.inSeconds.remainder(60));
    return'$minutes minutes and $seconds seconds';}

  int secCounter = 10;
  int counter = 10;

  void diffTimer() {
    counter = 10;
    _diffTimer = Timer.periodic(Duration(seconds: 1),(timer) {
      if (counter > 0) {
        setState(() {
          counter --;
        });
      }else {
        timer.cancel();
        checkDiffGoal();
      }
    });
  }

  void startTimer() {
    secCounter = 10;
    _timer = Timer.periodic(Duration(seconds: 1),(timer) {
      if (secCounter > 0) {
        setState(() {
          secCounter --;
        });
      }else {
        timer.cancel();
        checkGoal();
      }
    });
  }

void checkGoal() async{
    if (goalTime == 0 && min < 60){
      await updateCompletion();
    }
    else if (hours < goalTime) {
      await updateCompletion();
    } else {
      Utils.snackBar(context, 'Goal has not been completed');
    }
}

void checkDiffGoal() async{
    if (diffMin < diffGoalTime) {
      await updateDiffCompletion();
    }
    else {
      Utils.snackBar(context, 'Goal has not been completed',);
    }
}
  Future<void> startService() async{
    if(Platform.isAndroid) {
      final methodChannel = MethodChannel("com.example/background_services");
      String data = await methodChannel.invokeMethod("startService");
      debugPrint('startService: $data');
    }
  }

  Future <void> stopService() async {
    if(Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example/background_services");
      String data = await methodChannel.invokeMethod("stopService");
      debugPrint('stopService: $data');
    }
  }

  //refresh database when ever updated
  @override
  void initState() {
    super.initState();
    //refresh future content per update (Useful fo updating goals)
    refreshGoals();
    refreshScreenTime();
    WidgetsBinding.instance?.addObserver(this);
    NotificationAPI.init(initScheduled: true);
    listenNotify();
    tz.initializeTimeZones();
  }
  void listenNotify() => NotificationAPI.onNotification;

  //closing database when app is down
  @override
  void dispose() {
    //closes db
    UserDatabase.instance.closeDB();
    DiffTimeDatabase.instance.closeDB();
    ScreenTimeDatabase.instance.closeSTDB();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      bool? isScreenLocked = await isLockScreen();
      if(isStartService == false) {
        startService();
        setState(()=> isStartService = true);
      }
      if (isScreenLocked == true) {
        setState(() {
          stopTime = DateTime.now();
          screenCounter ++;
        });
        await submit();
        print('screenCounter = $screenCounter');
        NotificationAPI.displayNotification(
          title:'The time has stopped',
          body:'TIME HAS STOPPED',
          payload: 'HaHaMan',);


      }
    } else
      if (state == AppLifecycleState.resumed ) {
      setState(() {
        startTime = DateTime.now();
      });
      refreshScreenTime();
      NotificationAPI.displayNotification(
        title:'The timer has started',
        body:'TIME HAS START',
        payload: 'HoHoMan',);
    }

  }

  Future submit()async {
    //Duration between initial time to final time
    Duration difference = stopTime.difference(startTime);
    final diffTime = difference.inSeconds;
    print(diffTime);
    timeStamp = DateFormat.yMd().format(DateTime.now());
    final finalTime = ScreenContents(
        stopTime: DateTime.now(),
        startTime: startTime,
        diffTime: diffTime,
        createdTime: timeStamp
    );
    await ScreenTimeDatabase.instance.createST(finalTime);
  }

  Future refreshDiffGoal() async {
    this.diffGoal = await DiffTimeDatabase.instance.readDiffGoal(currentDiffGoalId);
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
      final totalAvg = screenContent.map((m) => (m.diffTime)).reduce((a, b) => a + b)/screenContent.length;
      await ScreenTimeDatabase.instance.totalDiffTime();
      await ScreenTimeDatabase.instance.findTotalTime();
      this.finalTime = ScreenTimeDatabase.finalTime;

      final avg = this.finalTime/(ScreenTimeDatabase.countToday);
      setState(() {
        averageSec = avg.round();
        totalSec = totalAvg.round();
      });

      calculateTotalTime();
      calculateDiffTime();
    }
  }

  //updates content when ever new content added
  Future refreshGoals() async {
    //when loading database
    setState(() => isLoading = true);
    //refreshes all goals when new data added
    this.goals = await UserDatabase.instance.readAllGoals();
    this.diffGoals = await DiffTimeDatabase.instance.readAllDiffGoals();
    setState(() => isLoading = false);
  }


  Future updateCompletion() async {
    setState(() {
      currentGoalId = UserDatabase.goalID;
    });
    print('the updateCompletion id = $currentGoalId');
    await refreshGoal();
    final currentGoal = goal!.copy(
    isCompleted: true
  );
    await UserDatabase.instance.update(currentGoal);
    Utils.showSnackBar(context, 'the goal of $goalTime has been competed!');
  }

  Future updateDiffCompletion() async {
    setState(() {
      currentDiffGoalId = DiffTimeDatabase.diffGoalId;
    });
    print('id of diffTIme $currentDiffGoalId');
    await refreshDiffGoal();

    final currentDiffGoal = diffGoal!.copy(
      isDiffComplete: true
    );
    await DiffTimeDatabase.instance.updateDiffGoal(currentDiffGoal);
    Utils.showSnackBar(context, 'The difference goal of $diffGoalTime is completed!');
  }

  Future updateGoal() async {
    print(_timer);
    _timer.cancel();
    this.currentGoalId = UserDatabase.goalID;
    print('the updateGoal id = $currentGoalId');
    await refreshGoal();

    final currentGoal = goal!.copy(
      isCompleted: false,
      goalTime: this.goalTime
    );
    await UserDatabase.instance.update(currentGoal);
    startTimer();
    Utils.showSnackBar(context, 'Goal has been updated! Timer set to 24 hours');
  }

  Future updateDiffGoal() async {
    _diffTimer.cancel();
    this.currentDiffGoalId = DiffTimeDatabase.diffGoalId;
    print ('the diffGoal id = $currentDiffGoalId');
    await refreshDiffGoal();

    final currentGoal = diffGoal!.copy(
      isDiffComplete : false,
      goalDiff: this.diffGoalTime
    );
    await DiffTimeDatabase.instance.updateDiffGoal(currentGoal);
    diffTimer();
    Utils.showSnackBar(context, 'Goal has been updated! Timer set to 1 hour');
  }

  Future addGoal() async {
    //add all the content from the fields into a single statement
    final goalA = UserContent(
      goalTime: goalTime,
      isCompleted: false,
      createdTime: DateTime.now(),
    );
    await UserDatabase.instance.create(goalA);
    startTimer();
    numOfCompleted();
  }

  Future addDiffGoal() async {
    final goalC = GoalContent(
        isDiffComplete: false,
        goalDiff: diffGoalTime,
        createdTime: DateTime.now()
    );
    await DiffTimeDatabase.instance.createDiffGoal(goalC);
    diffTimer();
  }

  void addOrUpdateDiffTime() async {
    if (counter > 0 && diffGoals.isNotEmpty){
      await updateDiffGoal();
    }
    else {
      await addDiffGoal();
    }
  }

  //add or update
  void addOrUpdateTotalTime() async{
    if (secCounter > 0 && goals.isNotEmpty) {
      await updateGoal();
    }else {
      print('sec is 0');
      await addGoal();
    }
  }


  void numOfCompleted() async {
    int? countC = await UserDatabase.instance.countCompletedGoals();
    int? countUC = await UserDatabase.instance.countUnCompletedGoals();
    int? countDC = await DiffTimeDatabase.instance.countDiffGoalsC();
    int? countDUC = await DiffTimeDatabase.instance.countDiffGoalsUC();


    final totalNum = (countC! + countDC! + countUC! + countDUC!);
    final percentageCNum = (((countC + countDC) / totalNum)*100).round();
    final percentageUCNum = (((countUC + countDUC )/totalNum)*100).round();
    setState(() {
      completedNum = (countC + countDC);
      unCompletedNum = (countUC + countDUC);
      percentageUC = percentageUCNum;
      percentageC = percentageCNum;
    });
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
              ElevatedButton(onPressed:() async {
                   await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScreenTimePage()));
                   //Once created refresh goals display page
                  refreshScreenTime();
                  refreshGoals();
                  },
                  child: Icon(Icons.atm),
              ),

                Container(
                  child: Text('$hours : $min : $sec',
                  style: TextStyle(color:Colors.white, fontSize: 30),
                  ),
                ),

                Container(
                  child: Text('$diffH : $diffMin : $diffSec',
                    style: TextStyle(color: Colors.white, fontSize: 30,),
                  ),
                ),
              ]
            ),
            alignment: Alignment.centerRight,
          ),
          Container(
            height: 300,
            child: SfCircularChart(
              title: ChartTitle(text:'Goal Chart'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CircularSeries>[DoughnutSeries<GoalCompletionData, String>(
                    dataSource: getChartData(),
                    explode: true,
                    explodeOffset: '8%',
                    xValueMapper: (GoalCompletionData data, _) => data.name,
                    yValueMapper: (GoalCompletionData data, _) => data.isComplete,
                    dataLabelMapper: (GoalCompletionData data, _) => data.numPercent,
                    pointColorMapper: (GoalCompletionData data, _) => data.pointColor,
                    dataLabelSettings: DataLabelSettings (isVisible: true),
                )
              ],
            ),
          ),

          Container(
            width: 250,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget> [
                  Container(

                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,

                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Utils.showSheet(context,
                                child: buildPicker(),
                                onClicked: () {
                                  final goalValue = goalValues[goalIndex];
                                  Utils.showSnackBar(context, '"$goalValue" has been selected, Survive the day without using your phone over $goalIndex hours');
                                  Navigator.pop(context);
                                  setState(() {
                                    goalTime = goalIndex;
                                    this.createdTime = DateTime.now();
                                  });
                                  addOrUpdateTotalTime();
                                  refreshGoals();
                                  numOfCompleted();
                                });
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
                              constraints: BoxConstraints(maxWidth: 350.0, maxHeight: 40),
                              alignment: Alignment.center,
                              child: Text('Use your phone under $goalIndex hours',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24,),

                        ElevatedButton (
                            onPressed: () => Utils.showSheet(context,
                                child: buildTimerPicker(),
                                onClicked: () {
                                  final timeValues = values[index];
                                  final timeValue = int.parse(timeValues);
                                  setState(() {
                                    diffGoalTime = timeValue;
                                    this.createdTime = DateTime.now();
                                  });
                                  addOrUpdateDiffTime();
                                  refreshGoals();
                                  Utils.showSnackBar(context, '$timeValues minutes has been selected');
                                  Navigator.pop(context);
                                }),
                            style: ElevatedButton.styleFrom(
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                              padding: EdgeInsets.all(0.0),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xff64B6FF), Color(0xff374ABE)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: Container (
                                constraints: BoxConstraints(maxWidth: 350.0, maxHeight: 40),
                                alignment: Alignment.center,
                                child: Text('Get less than an average of $index per hour',
                                  style: TextStyle(color: Colors.white, fontSize: 20)
                                ),
                              ),
                            ),
                          ),
                      ],),
                  ),
                ]),
          ),
         TextButton(onPressed: () => NotificationAPI.displayNotification(
               title:'hehe',
               body:'HEHEEHEHEHEHEHHEHE',
               payload: 'HEHEman',),
             child:Text('Notification', style: TextStyle(fontSize: 24), ),
             style: TextButton.styleFrom(
               backgroundColor: Colors.white,
             ),
         ),

          TextButton(
            onPressed: () => NotificationAPI.displayTimedNotification(
              title: 'Scheduled Date',
              body: 'TODO: ADD SCHEDULED MESSAGE',
              payload: 'DO YOUR GOALS',
              scheduledDate: DateTime.now().add(Duration(seconds: 15))
          ),
            child: Text('Scheduled Notification',
            style: TextStyle(fontSize: 24),),
              style: TextButton.styleFrom(
              backgroundColor: Colors.white,),
            ),

          MaterialButton(onPressed: () {
            if (isStartService == false) {
              startService();
              setState(()=> isStartService = true);
            } else {
              stopService();
              setState(()=> isStartService = false);
            }
          }, color: Colors.orange, child: Text((isStartService == false)? "startService" : "stopService"),
          )
        ]),
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

  Widget buildTimerPicker() => SizedBox(
    height: 180,
    child: CupertinoPicker(
      itemExtent: 64,
      diameterRatio: 0.7,
      looping: true,
      onSelectedItemChanged: (index) => setState(() => this.index = index),
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: Colors.pink.withOpacity(0.12),
        ),
      children: Utils.modelBuilder<String>(
          values, (index, values) {
        final isSelected = this.index == index;
        final color = isSelected ? Colors.pink : Colors.black;
        return Center (
          child: Text(
            values,
            style: TextStyle(color: color, fontSize: 24),
          ),
        );})
    ),
  );

  List<GoalCompletionData> getChartData() {
    final finalPercentC = ('$percentageC%').toString();
    final finalPercentUC = ('$percentageUC%').toString();
    final List<GoalCompletionData> chartData = <GoalCompletionData>[
      GoalCompletionData(completedNum, 'Completed', finalPercentC, Colors.indigoAccent),
      GoalCompletionData(unCompletedNum, 'Not Completed', finalPercentUC, Colors.redAccent)
    ];
    return chartData;
  }
}

class GoalCompletionData {
  GoalCompletionData (this.isComplete, this.name, this.numPercent, this.pointColor);
  //the data of if a goal is completed or not
  final int? isComplete;
  final String name;
  final String numPercent;
  final Color pointColor;
}

class NotificationAPI {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();


  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          'channel description',
          importance: Importance.max
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final iOS = IOSInitializationSettings();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
        settings, onSelectNotification: (payload) async {
      onNotification.add(payload);
    });
  }

  static Future displayNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
          id, title, body, await _notificationDetails(), payload: payload);

  static Future displayTimedNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime

      );

  static void dailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDaily(Time(9)),
          await _notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local );
    final date = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour,time.minute, time.second);

    return date.isBefore(now) ? date.add(Duration(days: 1)): date;
  }
}
