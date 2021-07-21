///converts SQL into json, maps and genral model of sql database for Screen Time
final String ScreenTimeTable = 'Screen_Time';

class STFields {
  static final List<String> values = [
    ST_id, startTime, stopTime, averageTime
  ];

  static final String ST_id = '_STid';
  static final String startTime = 'startTime';
  static final String stopTime = 'stopTime';
  static final String averageTime = 'Av_Time';

}