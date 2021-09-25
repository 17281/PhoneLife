import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:rxdart/rxdart.dart';
import '../Utils.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:phoneapp/model/DiffTime.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:phoneapp/page/NavBar.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

}

void startForegroundService() async {
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      _ContentPageState();
    },
    onStopped: () {
      NotificationAPI.displayTimedNotification(
        title: 'Friendly Reminder',
          body: "I'm always watching...",
          payload: "HEHEMAN",
          scheduledDate: DateTime.now().add(Duration(minutes: 30)));
    },
    title: "Flutter Foreground Service",
    content: "running in background",
    iconName: "ic_android_black_24dp",
  );
}

void globalForegroundService() {
  debugPrint("current datetime is ${DateTime.now()}");
}

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

//the state of content page remains as a stateful widget
class _ContentPageState extends State<ContentPage> with WidgetsBindingObserver{

  static bool goalChosen = false;
  static bool diffGoalChosen = false;
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
  int hours = 0;
  int min = 0;
  int sec = 0;

  //average difference
  int diffH = 0;
  int diffMin = 0;
  int diffSec = 0;

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
    setState(() => goalChosen = false);
    if (goalTime == 0 && min < 60){
      await updateCompletion();
    }
    else if (hours < goalTime) {
      await updateCompletion();
    } else {
      NotificationAPI.displayNotification(
          title: 'MISSION FAILED...',
          body: 'Your screen time has exceeded your goal "$goalTime hours of phone usage"',
          payload: 'When plan A fails you still got 25 letters left'
      );
      Utils.snackBar(context, 'Goal has not been completed');
    }
}

void checkDiffGoal() async{
    setState(() => diffGoalChosen = false);
    if (diffMin < diffGoalTime) {
      await updateDiffCompletion();
    }
    else {
      NotificationAPI.displayNotification(
          title: 'MISSION FAILED...',
          body: 'Your screen time has exceeded your goal "$diffGoalTime average minutes of phone usage"',
          payload: 'Sometimes you gotta JUST DO IT!!'
      );
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
    NotificationAPI.dailyNotification(
        title: 'GOOD MORNING',
        body: 'New day, New you. Are you ready to beat your past!?',
        payload: 'Phone Champion',
        scheduledDate: DateTime.now(),);
    startForegroundService();
    goalNotification();
    notifyEveryHour();
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

  void notifyEveryHour() {
    Timer.periodic(Duration(hours: 1), (timer) {
      NotificationAPI.displayNotification(
          title: 'Look Out',
          body: 'Experts say taking a 20 Seconds break for every 20 Minutes on screen can help reduce eye fatigue',
          payload: '#20/20 RULE'
      );
    });
  }

  void goalNotification () async {
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (hours > 1) {
        NotificationAPI.displayNotification(
          title: 'Heads Up',
          body: 'Your screen time is over 1 Hour',
          payload: 'Remember your training'
      );
      }

      if (hours > 2) {
        NotificationAPI.displayNotification(
            title: 'Healthy Tip',
            body: 'Your screen time is over 2 hours',
            payload: 'I suggest taking a 10 Min break'
        );
      }

      if (hours > 3) {
        NotificationAPI.displayNotification(
            title: 'Caution Advised',
            body: 'Your screen time has just passed 3 Hours, RECOMMEND: Water on cereal :p',
            payload: 'Welcome to the average zone'
        );
      }

      if (hours > 4) {
        NotificationAPI.displayNotification(
            title: 'WARNING',
            body: 'Screen time exceeding 4 Hours! ',
            payload: 'Taking a 30 Min screen break is highly advised'
        );
      }

      if (hours > 5) {
        NotificationAPI.displayNotification(
            title: 'DANGER!!',
            body: 'Screen time EXCEEDING 5 Hours!!',
            payload: 'ANY LONGER SCREEN TIME WILL RESULT IN @#@^&#*&#%^@!'
        );
      }

      if (diffMin > 5) {
        NotificationAPI.displayNotification(
            title: 'Heads Up',
            body: 'Your average screen viewing passed 5 Minutes',
            payload: 'Remember your training'
        );
      }
      if (diffMin > 10) {
        NotificationAPI.displayNotification(
            title: 'CAUTION',
            body: 'Your average screen viewing passed 10 Minutes',
            payload: 'Best to take a 20 min screen break ;P'
        );
      }

      if (diffMin > 15) {
        NotificationAPI.displayNotification(
            title: 'WARNING!!',
            body: 'Average screen time is over 15 Minutes. I am always watching',
            payload: 'Silly Baka! You better take a 40 min screen break!'
        );
      }

      if (goalChosen == false) {
        NotificationAPI.displayTimedNotification(
            title: 'NANI!?, GOAL NOT CHOSEN >:(',
            body: 'Even if completing a goal is hard, attempting it is harder',
            payload: 'Select your daily goal',
            scheduledDate: DateTime.now().add(Duration(minutes: 5))
        );
      }

      if (diffGoalChosen == false) {
        NotificationAPI.displayTimedNotification(
            title: 'First steps are always the hardest',
            body: 'Commitment is key to every success',
            payload: 'Select your hourly goal',
          scheduledDate: DateTime.now().add(Duration(minutes: 5))
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    bool? isScreenLocked = await isLockScreen();
    if (state == AppLifecycleState.inactive) {
      NotificationAPI.displayTimedNotification(
          title: 'REMINDER',
          body: 'Winners never quit and quitters never win!',
          payload: 'Change your life',
          scheduledDate: DateTime.now().add(Duration(minutes: 15)));

      if (isScreenLocked == true) {
        screenCounter = 0;
        setState(() {
          stopTime = DateTime.now();
          screenCounter ++;
        });
        await submit();
        print('screenCounter = $screenCounter');
      }
    } else
    if (state == AppLifecycleState.resumed) {
      setState(() {
        startTime = DateTime.now();
      });
      refreshScreenTime();
    }
    if (state == AppLifecycleState.paused) {

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
    NotificationAPI.displayNotification(
      title: 'HOO-RAAY, Goal completed!!',
      body: 'Your dream goal of $goalTime hours has been completed...',
      payload: 'Do you have what it takes to ASCEND to greater goodness');
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
    NotificationAPI.displayNotification(
      title: 'Talented or Luck',
      body: 'The average of $diffGoalTime minutes goal has been completed...',
      payload: 'Are you ready to change your LIFE');
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
    setState(() => goalChosen = true);
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
    setState(() => diffGoalChosen = true);
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
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final _hours = twoDigits(hours);
    final _min = twoDigits(min);
    final _sec = twoDigits(sec);
    final _diffHours = twoDigits(diffH);
    final _diffMin = twoDigits(diffMin);
    final _diffSec = twoDigits(diffSec);
    return Scaffold(
      drawer: NavBar(),
        appBar: AppBar(
          // title: Text('Number of completed goals: $completedNum'),
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

                Container(

                  child: Text('$_hours : $_min : $_sec',
                  style: TextStyle(color:Colors.white, fontSize: 30),
                  ),
                ),

                Container(
                  child: Text('$_diffHours : $_diffMin : $_diffSec',
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
                    startAngle: 270,
                    endAngle: 90,
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

          MaterialButton(onPressed: () async {
            if (isStartService == false) {
              startForegroundService();
              setState(()=> isStartService = true);
            } else {
              await FlutterForegroundPlugin.stopForegroundService();
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
          _scheduleDaily(Time(9,)),
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
