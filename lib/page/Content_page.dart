import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Edit_Goals.dart';
import 'package:phoneapp/widget/Goal_card_widget.dart';
import 'Goal_detail_page.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/page/Screen_Time_Page.dart';
import 'package:phoneapp/widget/Graph_Widget.dart';



class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

//the state of content page remains as a stateful widget
class _ContentPageState extends State<ContentPage> {
  //finds all 'goals' from userTable
  late List<UserContent> goals;
  //finds all screen time value
  late List<ScreenContents> screenTime;
  bool isLoading = false;

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
    //sets database to be async loading to the page
    setState(() => isLoading = true);{
      //refresh and display new data on page
      this.screenTime = await ScreenTimeDatabase.instance.readAllTime();
      //after database loads, change the loading symbol to off
      setState(() => isLoading = false);{
      }
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


  @override
  ///Main Page display
  Widget build(BuildContext context) =>


    // Scaffold(
    //   appBar: AppBar (
    //       title: Text('Screen time', style: TextStyle(fontSize: 30),)
    //   ),
    //   body:
    //   Expanded( child: Column(
    //     //displaying 2 widget trees
    //
    //     children: [
    //       ///ScreenTime display Widget
    //       Container(
    //         child:
    //         // Center (
    //         //   child:
    //           isLoading ? CircularProgressIndicator() : screenTime.isEmpty
    //           //return a no data found to tell the user
    //             ? Text('No Data found', style: TextStyle(color: Colors.white , fontSize: 24),
    //           ) : buildTimeGraph()
    //         ),
    //       // ),
    //       ///Goal display Widget
    //       Container(
    //         child:
    //         // Center(
    //         //   //loading display
    //         //   child:
    //           isLoading ? CircularProgressIndicator() : goals.isEmpty
    //           //if goals returned is empty then return 'No Goals
    //           // text styling
    //           ? Text('No data found', style: TextStyle(color: Colors.white, fontSize: 24),
    //           )
    //           //build the Goals (By calling the buildGoals function/widget)
    //           : buildGoals(),
    //         ),
    //       // ),
    //     ], //Children
    //   ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //   backgroundColor: Colors.white12,
    //   //adds icon for adding new goals
    //   // TODO: Create dynamic adding system rather manual input
    //   child: Icon(Icons.add),
    //
    //   //makes the object interactable, when pressed, await for response
    //   onPressed: () async {
    //     //when pressed activates editing page (creates new page for editing.
    //     await Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => AddEditGoalPage()),
    //     );
    //     //Once created refresh goals display page
    //     refreshGoals();
    //   },
    // ),
    // );

//TODO: add graphing function here
  Widget buildTimeGraph() =>
  StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: screenTime.length,
    //default
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final sTime = screenTime[index];
      //detects when the user taps a button
      return GestureDetector(
        //when user clicks on tap
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            //builds the page where new goals are added and then refresh display page.
            //builds content based on goalId = id
            builder: (context) => ScreenTimePage(timeID: sTime.ST_id!),
          ));
          //calls function to refresh page.
          refreshScreenTime();
        },
        child: TimeGraphWidget(screenContent: sTime, index: index),
      );  },
  );



  // TODO: find a better looking goal display---------------------------
  Widget buildGoals() =>
  //builds the display for goals
      StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: goals.length,
        //default
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final goal = goals[index];
          //detects when the user taps a button
          return GestureDetector(
            //when user clicks on tap
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                //builds the page where new goals are added and then refresh display page.
                //builds content based on goalId = id
                builder: (context) => GoalDetailPage(goalID: goal.id!),
              ));
              //calls function to refresh page.
              refreshGoals();
            },
            //uses the card widget in folder to display data
            //TODO: find better looking display plz
            child: GoalCardWidget(goal: goal, index: index),
          );  },
      );
}