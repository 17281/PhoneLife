import 'package:flutter/material.dart';

class TimeFormWidget extends StatelessWidget {
  final String? averageTime;
  final ValueChanged<String> onChangedAverageTime;

//Validating methods of inserting, ie. Name can't be null
  const TimeFormWidget({
    Key? key,
    this.averageTime = '',
    required this.onChangedAverageTime,
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
              buildAverageTime(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  //TextForm is validating input methods
  Widget buildAverageTime() =>
      TextFormField(
        maxLines: 1,
        initialValue: averageTime,
        //styling
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Average Screen Time',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        onChanged: onChangedAverageTime,
      );


}