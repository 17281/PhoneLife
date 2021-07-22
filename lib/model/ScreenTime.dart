

///converts SQL into json, maps and genral model of sql database for Screen Time
final String ScreenTimeTable = 'Screen_Time';

class STFields {
  static final List<String> values = [
    ST_id, startTime, stopTime, averageTime, totalTime
  ];

  static final String totalTime= 'totalTime';
  static final String ST_id = '_STid';
  static final String startTime = 'startTime';
  static final String stopTime = 'stopTime';
  static final String averageTime = 'averageTime';

}

class ScreenContents {
  final int? ST_id;
  final String totalTime;
  final DateTime startTime;
  final DateTime stopTime;
  final String averageTime;

  //constructs contents of the column in the table
  const ScreenContents ({
    this.ST_id,
    required this.totalTime,
    required this.averageTime,
    required this.stopTime,
    required this.startTime
});


//Preparing contents to be converted
ScreenContents copy ({
  int? ST_id,
  String? totalTime,
  String? averageTime,
  DateTime? startTime,
  DateTime? stopTime

}) =>
//Setting types to each column objects before converting
    ScreenContents(
    ST_id: ST_id ?? this.ST_id,
    totalTime: totalTime ?? this.totalTime,
    averageTime: averageTime ?? this.averageTime,
    stopTime: stopTime ?? this.stopTime,
    startTime: startTime ?? this.startTime,
);

//converting to json
static ScreenContents fromJson (Map<String, Object?> json) => ScreenContents(
    averageTime: json[STFields.averageTime] as String,
    stopTime: DateTime.parse(json[STFields.stopTime]as String),
    startTime: DateTime.parse(json[STFields.startTime] as String),
    totalTime: json[STFields.totalTime] as String,
    ST_id: json[STFields.ST_id] as int?);

//converting maps
  Map<String, Object?>toJson() => {
    //a map of key values
    //Table name:Key: other Value
    STFields.ST_id: ST_id,
    STFields.averageTime: averageTime,
    STFields.totalTime: totalTime,
    //TODO: Change '.toIso8601String' to different string method to enable adding numbers in screen time.
    STFields.startTime: startTime.toIso8601String(),
    STFields.stopTime: stopTime.toIso8601String(),
  };
}