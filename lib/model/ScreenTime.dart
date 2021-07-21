///converts SQL into json, maps and genral model of sql database for Screen Time
final String ScreenTimeTable = 'Screen_Time';

class STFields {
  static final List<String> values = [
    STid, startTime, stopTime, averageTime
  ];

  static final String STid = '_STid';
  static final String startTime = 'startTime';
  static final String stopTime = 'stopTime';
  static final String averageTime = 'Av_Time';

}