import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Time_Detail_page.dart';
import '../Utils.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/page/Screen_Time_Page.dart';
import 'package:phoneapp/widget/Graph_Widget.dart';



class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}


//the state of content page remains as a stateful widget
class _ContentPageState extends State<ContentPage> {
  int goalIndex = 2;
  static List<String> goalValues = [
    'No Phone?!?!',
    'Living the life',
    'The Average Joe',
    'Easy Life',
    'Baby Mode',
  ];


  //final int goalID;
  //Initiation of Goal Table variables
  late DateTime createdTime;
  late int goalTime;
  late bool isCompleted;
  late UserContent? goal;

  //finds all 'goals' from userTable
  late List<UserContent> goals;
  //finds all screen time value
  late List<ScreenContents> screenContent;
  bool isLoading = false;
  bool isValid = false;

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


//Updating screen time data displayed
  Future refreshScreenTime() async {
    //sets database to be async loading to the pag
    setState(() => isLoading = true);{
      //refresh and display new data on page
      this.screenContent = await ScreenTimeDatabase.instance.readAllTime();
      //after database loads, change the loading symbol to off
      setState(() => isLoading = false);

      //.reduce((value, time) => value.add(time));
      final num avg = screenContent.map((m) => (m.diffTime)).reduce((a, b) => a + b)/ screenContent.length;
      print (avg);
    }
  }

  //updates content when ever new content added
  Future refreshGoals() async {
    //when loading database
    setState(() => isLoading = true);
    //this.goal = await UserDatabase.instance.readGoal(widget.goalID);
    //refreshes all goals when new data added
    this.goals = await UserDatabase.instance.readAllGoals();
    setState(() => isLoading = false);
  }


  Future addOrUpdateGoal() async {
    if (isValid == true) {
      final isUpdating = createdTime != DateTime.now();
      if (isUpdating) {
        await updateGoal();
      }else
        await addGoal();
    }
    Navigator.of(context).pop();
}

  Future updateGoal() async {
    //copies all the content fields and then display any new data added
    // final userGoal = widget.goal!.copy(
    //   isCompleted: isCompleted,
    //   goalTime: goalTime,
    // );
    // //update the content
    // await UserDatabase.instance.update(userGoal);
  }

  Future addGoal() async {
    //add all the content from the fields into a single statement
    final goal = UserContent(
      goalTime: goalTime,
      isCompleted: false,
      createdTime: DateTime.now(),
    );
    //create the submitted data into database
    await UserDatabase.instance.create(goal);
  }



  Widget buildTime() =>
      //builds the display for goals
  StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: screenContent.length,
    //default
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final time = screenContent[index];
      //detects when the user taps a button
      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TimeDetailPage(timeID: time.ST_id!),)
          );
        },

        child: TimeGraphWidget(screenContent: time, index: index),
      );
    },
  );

  @override
  ///Main Page display
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screen Time test'),
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
                  refreshScreenTime();},
                  child: Icon(Icons.atm),
              )
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
                      onPressed: () {
                        Utils.showSheet(context,
                          child: buildPicker(),
                          onClicked: () {final goalValue = goalValues[goalIndex];
                          Utils.showSnackBar(context, 'Selected "$goalValue", Your goal today is: Screen time less than $goalIndex hours');
                          Navigator.pop(context);});

                        //addOrUpdateGoal();
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
                        child: Text('Screen time less than $goalIndex hours', style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    ),
                  ),
                  ),
                  // SizedBox(height: 20),
                ]
            ),
          ),

          Container(
            height: 300,
            child: isLoading ? CircularProgressIndicator() : screenContent.isEmpty ?
              Text('No data' , style: TextStyle(color: Colors.white, fontSize: 24),
            ) : buildTime(),
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
          setState(() {
            isValid = true;
            this.goalTime = goalIndex;
            this.createdTime = DateTime.now();
          });
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
}




