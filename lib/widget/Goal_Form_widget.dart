import 'package:flutter/material.dart';

class GoalFormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? name;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedDescription;
}