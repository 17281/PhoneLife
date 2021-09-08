//User table 
final String diffGoal = 'diffGoal';
//contents created in SQL
class GoalFields {
  static final List<String> values = [
    ///add all fields
    id, isDiffComplete, goalDiff ,time, 
  ];

  static final String id = '_id';
  static final String isDiffComplete = 'isDiffComplete';
  static final String goalDiff = 'goalDiff';
  static final String time = 'time';
}


//Contents of table in flutter
class GoalContent {
  final int? id;
  final bool isDiffComplete;
  final int goalDiff;
  final DateTime createdTime;

  //constructs users table contents
  const GoalContent ({
    this.id,
    required this.isDiffComplete,
    required this.goalDiff,
    required this.createdTime,
  });

  //copies objects and changes items within database
  GoalContent copy({
    //primary key for id
    int? id,
    bool? isDiffComplete,
    int? goalDiff,
    DateTime? createdTime,

  }) =>
      GoalContent(
        //setting type to the listed contents
        id: id ?? this.id,
        isDiffComplete: isDiffComplete ?? this.isDiffComplete,
        goalDiff: goalDiff ?? this.goalDiff,
        createdTime: createdTime ?? this.createdTime,
      );

  //converting map fields into json (for data inserting)
  static GoalContent fromJson(Map<String, Object?> json) => GoalContent(
    id: json[GoalFields.id] as int?,
    goalDiff: json[GoalFields.goalDiff] as int,
    //description: json[GoalFields.description] as String,
    //specials cases that need extra converting i.e bool and tim
    createdTime: DateTime.parse(json[GoalFields.time] as String),
    isDiffComplete: json[GoalFields.isDiffComplete] == 1,
  );


  // Map to allow data to be inserted into sql
  Map<String, Object?>toJson() => {
    //a map of key values
    GoalFields.id: id,
    GoalFields.goalDiff: goalDiff,
    //Bool and DateTime needs conversion before inserted into sql
    GoalFields.isDiffComplete: isDiffComplete ? 1 : 0,
    //converts time to string
    GoalFields.time: createdTime.toIso8601String(),
  };
}