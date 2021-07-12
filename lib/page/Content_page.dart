import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/Goals.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}
class _ContentPageState extends State<ContentPage> {
  //finds all 'goals' from userTable
  late List<UserContent> goals;
  bool isLoading = false;

  //refresh database when ever updated
  @override
  void initState() {
    super.initState();
    //refresh future content per update (Useful fo updating goals)
    refreshContents();
  }

  //closing database when app is down
  @override
  void dispose() {
    //closes db
    UserDatabase.instance.closeDB();
    super.dispose();
  }

  //updates content when ever new content added
  Future refreshContents() async {
    //when loading database
    setState(() => isLoading = true);

    this.goals = await UserDatabase.instance.readAllGoals();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(

  );

}