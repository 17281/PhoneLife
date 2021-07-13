import 'package:flutter/material.dart';

class GoalFormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? name;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDescription;

//Validating methods of inserting, ie. Name can't be null
  const GoalFormWidget({
    Key? key,
    this.isImportant = false,
    this.name = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedName,
    required this.onChangedDescription,
  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

