import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Edit_Goals.dart';
import 'package:phoneapp/widget/Goal_card_widget.dart';
import 'Goal_detail_page.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/page/Screen_Time_Page.dart';
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
      Scaffold(
          appBar: AppBar(
            //Text Style can be added for different Text sizes.
            title: Text('Screen Time', style: TextStyle(fontSize: 30),),

          ),

          body: Center(
            child: isLoading
            //loading display
            ? CircularProgressIndicator()
            : goals.isEmpty && screenTime.isEmpty
            //if goals returned is empty then return 'No Goals
            ? Text('No data found',
              //text styling
              style: TextStyle(color: Colors.white, fontSize: 24),
            )
            //build the Goals (By calling the buildGoals function/widget)
            : buildGoals(),
          ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white12,
          //adds icon for adding new goals
          // TODO: Create dynamic adding system rather manual input
          child: Icon(Icons.add),

          //makes the object interactable, when pressed, await for response
          onPressed: () async {
            //when pressed activates editing page (creates new page for editing.
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditGoalPage()),
            );
            //Once created refresh goals display page
            refreshGoals();
          },
      ),
  );


  Widget buildTimeGraph() =>
  StaggeredGridView.countBuilder( padding: EdgeInsets.all(8),
    itemCount: screenTime.length,
    //default
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final STime = screenTime[index];
      //detects when the user taps a button
      return GestureDetector(
        //when user clicks on tap
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            //builds the page where new goals are added and then refresh display page.
            //builds content based on goalId = id
            builder: (context) => ScreenTimePage(timeID: STime.ST_id!),
          ));
          //calls function to refresh page.
          refreshScreenTime();
        },
        //uses the card widget in folder to display data
        //TODO: find better looking display plz
        child: TimeGraphWidget(timeGraph: timeGraph, index: index),
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