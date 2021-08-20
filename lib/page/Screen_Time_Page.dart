import 'package:phoneapp/db/User_database.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:flutter/material.dart';


class ScreenTimePage extends StatefulWidget {
 //displays where timeID = ST_ID from time database
  final ScreenContents? screenContent;
  const ScreenTimePage ({Key? key,
    this.screenContent,}) :super(key: key);

  @override
  _TimeDetailPageState createState() => _TimeDetailPageState();

}

class _TimeDetailPageState extends State <ScreenTimePage> {
  late String diffTime;
  late DateTime stopTime;
  late DateTime startTime;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }


  //TODO: add graph display return here
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [startButton(), stopButton(), submitButton()],
    ),
    body: Center(
    ),
  );

  Widget startButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(onPrimary: Colors.green, primary: Colors.blue),
          onPressed: () async {startTime = DateTime.now();}, child: Text('start time'),
        ),
    );
  }

  Widget stopButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(onPrimary: Colors.red, primary: Colors.orange),
        onPressed: () async {stopTime = DateTime.now();}, child: Text('Stop time'),
      ),
    );
  }

  Widget submitButton() {
    return Padding (
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton (
        style: ElevatedButton.styleFrom( onPrimary: Colors.red, primary: Colors.blueAccent),
        onPressed: () {submit();}, child: Text('Submit'),
        ),
      );
  }

  submit()async {
    //Duration between initial time to final time
    Duration difference = stopTime.difference(startTime);
    final diffTime = difference.inSeconds;
    print(diffTime);

    final finalTime = ScreenContents(
      stopTime: stopTime,
      startTime: startTime,
      diffTime: diffTime,
    );
    await ScreenTimeDatabase.instance.createST(finalTime);
  }


  // Duration parseDuration(String s)
  // {
  //   print(s);
  //   final splitTime = s.split(':').map((e) => e.trim()).toList();
  //   int? hours;
  //   int? minutes;
  //   int? seconds;
  //   int? milliseconds;
  //
  //   print (splitTime);
  //   for (String parts in splitTime) {
  //     print('Parts: ' + parts);
  //     final match = RegExp(r'^(\d+) (h|m|s|ms)$').matchAsPrefix(parts);
  //     if (match == null) throw FormatException('Wrong format');
  //
  //     int value = int.parse(match.group(1)!);
  //     String? unit = match.group(2);
  //
  //     switch(unit) {
  //
  //       case 'h' :
  //         if (hours!=null) {
  //           throw FormatException('Wrong hour duration');
  //         }
  //         hours = value;
  //         break;
  //
  //       case 'm' :
  //         if (minutes!=null) {
  //           throw FormatException('Wrong Min duration');
  //         }
  //       minutes = value;
  //       break;
  //
  //       case 's' :
  //         if (seconds!=null) {
  //           throw FormatException('Wrong seconds');
  //         }
  //         seconds = value;
  //         break;
  //
  //       case 'ms' :
  //         if (milliseconds!=null) {
  //           throw FormatException('milli wrong');
  //         }
  //         milliseconds = value;
  //         break;
  //
  //       default:
  //         throw FormatException('Invalid Duration format on $unit');
  //       }
  //     }
  //   return Duration(
  //       hours: hours ?? 0,
  //       minutes: minutes ?? 0,
  //       seconds: seconds ?? 0,
  //       milliseconds: milliseconds ?? 0);
  // }

  // parseDuration(String s)
  // {
  //   int hours = 0;
  //   int minutes = 0;
  //   int micros;
  //
  //   List<String> splitTime = s.split(':');
  //   print (splitTime);
  //   if (splitTime.length > 2) {
  //     hours = int.parse(splitTime[splitTime.length - 3]);
  //   }
  //   if (splitTime.length > 1) {
  //     minutes = int.parse(splitTime[splitTime.length - 2]);
  //   }
  //   micros = (double.parse(splitTime[splitTime.length - 1]* 100000.round()));
  //   return Duration(hours: hours, minutes: minutes, microseconds: micros);
  // }
}






