import 'package:flutter/material.dart';

class GoalFormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? name;
  ///final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedName;
  ///final ValueChanged<String> onChangedDescription;

//Validating methods of inserting, ie. Name can't be null
  const GoalFormWidget({
    Key? key,
    this.isImportant = false,
    this.name = '',
    required this.onChangedImportant,
    required this.onChangedName,
  }) : super(key: key);

  //Final displaying UI
  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Switch(
                    value: isImportant ?? false,
                    onChanged: onChangedImportant,
                  ),
                ],
              ),
              //builds Name and Description in Column
              buildName(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  //building the name widget for singular goal pages
  //TextForm is validating input methods
  Widget buildName() =>
      TextFormField(
        //only allows one line for name
        maxLines: 1,
        //Value inserted into database is name
        initialValue: name,
        //styling
        //TODO:Change TEXTSTYLE======================
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        //UI TODO: MIght Change this to a simple block format -------------
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Goal',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        //Validation of method
        validator: (name) =>
        //the name column can't be null
        name != null && name.isEmpty ? 'The name cannot be empty' : null,
        onChanged: onChangedName,
      );

}