import 'package:phoneapp/model/Goals.dart';

///converts SQL into json, maps and genral model of sql database for Screen Time
final String ScreenTimeTable = 'Screen_Time';

class STFields {
  static final List<String> values = [
    ST_id, startTime, stopTime, averageTime
  ];

  static final String ST_id = '_STid';
  static final String startTime = 'startTime';
  static final String stopTime = 'stopTime';
  static final String averageTime = 'averageTime';

}

class ScreenContents {
  final int? ST_id;
  final DateTime startTime;
  final DateTime stopTime;
  final String averageTime;

  //constructs contents of the column in the table
  const ScreenContents ({
    this.ST_id,
    required this.averageTime,
    required this.stopTime,
    required this.startTime
});
}

//Preparing contents to be converted
ScreenContents copy ({
  int? ST_id,
  String? averageTime,
  DateTime? startTime,
  DateTime? stopTime

}) =>
//Setting types to each column objects before converting
    ScreenContents(
    ST_id: ST_id ?? this.ST_id,
    averageTime: averageTime ?? this.averageTime,
    stopTime: stopTime ?? this.stopTime,
    startTime: startTime ?? this.startTime,
);