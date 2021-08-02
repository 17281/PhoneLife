import 'package:phoneapp/db/User_database.dart';
import 'package:flutter/material.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/widget/Goal_Form_widget.dart';

class AddEditGoalPage extends StatefulWidget {
  final UserContent? goal;
  const AddEditGoalPage({Key? key, this.goal}) : super(key: key);
  @override
  _AddEditGoalPageState createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage>{
  //creates a validation method for when users insert data into database
  final _formkey = GlobalKey<FormState>();
  late bool isImportant;
  late DateTime createdTime;
  late String name;

  //initiate database and conversions.
  @override
  void initState() {
    super.initState();
    //setting isImportant factor to false when created
    isImportant = widget.goal?.isImportant ?? false;
    //chang-able '' field
    name = widget.goal?.name ?? '';
    ///description = widget.goal?.description ?? '';
  }

  //build the editing widget
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      //input action - TODO: create simple sliding goal setting system
      actions: [buildButton()],
    ),
    body: Form(
      key: _formkey, child: GoalFormWidget(
      //links each database column to each field that will be changed.
      isImportant: isImportant,
      name: name,
      ///description: description,

      //When the form is valid, add data to database via placing the inputted from the FormWidget into a sql statement
      onChangedImportant: (isImportant) => setState(() => this.isImportant = isImportant),
      onChangedName: (name) => setState(() => this.name= name),
      //onChangedDescription: (description) =>setState(() => this.description = description),
    ),
    ),
  );

  Widget buildButton(){
    //only allow data to be pushed if name and description is not empty
    final isFormValid = name.isNotEmpty;
    //UI for the button
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.green,
          primary: isFormValid ? null : Colors.white,
        ),
        onPressed: addOrUpdateGoal,
        child: Text('Save'),
      ),
    );
  }

  ///When submit button is pressed then, Identify if the data returned is to be added or refreshed
  void addOrUpdateGoal() async {
    //Only if the validating key is correct then proceed to update or add new data.
    final isValid = _formkey.currentState!.validate();
    //when updating the data can't be Null
    if (isValid) {
      final isUpdating = widget.goal != null;

      //wait for updating database and then add new content
      if (isUpdating) {
        await updateGoal();
      } else {
        await addGoal();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateGoal() async {
    //copies all the content fields and then display any new data added
    final note = widget.goal!.copy(
      isImportant: isImportant,
      name: name,
      ///description: description,
    );

    //update the content
    await UserDatabase.instance.update(note);
  }

  Future addGoal() async {
    //add all the content from the fields into a single statement
    final goal = UserContent(
      name: name,
      ///description: description,
      isImportant: true,
      //date created for each goal
      //TODO:Using this, change the goals set each day to be dynamic
      createdTime: DateTime.now(),
    );
    //create the submitted data into database
    await UserDatabase.instance.create(goal);
  }

}
