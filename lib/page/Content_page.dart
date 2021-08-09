import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/page/Edit_Goals.dart';
import 'package:phoneapp/page/Time_Detail_page.dart';
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
  int index = 0;

  static List<String> goalValues = [
    'Living the life',
    'The Average Joe',
    'Middle Class',
    'Easy Life',
    'Baby Mode'
  ];


  //finds all 'goals' from userTable
  late List<UserContent> goals;
  //finds all screen time value
  late List<ScreenContents> screenContent;
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
      this.screenContent = await ScreenTimeDatabase.instance.readAllTime();
      //after database loads, change the loading symbol to off
      setState(() => isLoading = false);

      //
      // var avg = screenContent.map((m) => m.averageTime).reduce((a, b) => a+b);
      //     // / screenContent.length;
      // print (avg);

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
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GoalDetailPage(goalID: goal.id!),)
          );
        },
        child: GoalCardWidget(goal: goal, index: index),
      );
    },
  );

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
                  await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ScreenTimePage()));
    //Once created refresh goals display page
              refreshScreenTime();},
            child: Icon(Icons.atm),
              )
        ]
    ),
      alignment: Alignment.center,
    ),

          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // ElevatedButton( onPressed: () async {
                  //           await Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => AddEditGoalPage()));
                  //           //Once created refresh goals display page
                  //           refreshGoals();},
                  //   child: Icon(Icons.add),
                  // ),
                  // SizedBox(height: 20),
                  buildCustomPicker()



                ]
            ),
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
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
  Widget buildCustomPicker() => SizedBox(
    height: 300,
    child: CupertinoPicker(
      itemExtent: 64,
      onSelectedItemChanged: (index) => setState(() => index = this.index),
      children: modelBuilder<String> (

      ),

    ),
  );

}




