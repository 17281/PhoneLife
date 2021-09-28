import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneapp/page/Content_page.dart';
class Utils {

  static bool goalChosen = true;
  static bool diffGoalChosen = true;

  //Links the index with the respective model
  static List<Widget> modelBuilder<M>(
      List<M> models, Widget Function(int index, M model) builder) =>
      models.asMap().map<int, Widget>((index, model) => MapEntry(index, builder(index, model))).values.toList();

  //UI of the bottom box
  static void showSheet(
      BuildContext context, {
        required Widget child,
        required VoidCallback onClicked,
      }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text((goalChosen == false)? 'Done':'Update'),
            onPressed: onClicked,
          ),
        ),
      );  //UI of the bottom box

  static void showDiffSheet(
      BuildContext context, {
        required Widget child,
        required VoidCallback onClicked,
      }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text((diffGoalChosen == false) ? 'Done' : 'Update'),
            onPressed: onClicked,
          ),
        ),
      );

  //Bottom Notification
  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 30)),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void snackBar (BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 25)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void alertSnackBar (BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 20),),
      backgroundColor: Colors.orange,
    );
    ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
  }

}