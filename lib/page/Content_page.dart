import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phoneapp/db/notes_database.dart';
import 'package:phoneapp/model/note.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}
class _ContentPageState extends State<ContentPage> {
  late List<UserContent> notes;
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
    setState(() => isLoading = true);
    this.notes = await UserDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }



}