//Name of table created , This part is basically SQA but with json conversions
final String userTable = 'User';

//contents created in SQL
class UserFields {
  static final List<String> values = [
    ///add all fields
    id, isCompleted, goalTime ,time, //description
  ];

  static final String id = '_id';
  static final String isCompleted = 'isCompleted';
  static final String goalTime = 'goalTime';
  static final String time = 'time';
}


//Contents of table in flutter
class UserContent {
  final int? id;
  final bool isCompleted;
  final int goalTime;
  final DateTime createdTime;

  //constructs users table contents
  const UserContent ({
    this.id,
    required this.isCompleted,
    required this.goalTime,
    required this.createdTime,
});

  //copies objects and changes items within database
  UserContent copy({
    //primary key for id
    int? id,
    bool? isCompleted,
    int? goalTime,
    DateTime? createdTime,

}) =>
  UserContent(
    //setting type to the listed contents
    id: id ?? this.id,
    isCompleted: isCompleted ?? this.isCompleted,
    goalTime: goalTime ?? this.goalTime,
    createdTime: createdTime ?? this.createdTime,
  );

  //converting map fields into json (for data inserting)
  static UserContent fromJson(Map<String, Object?> json) => UserContent(
    id: json[UserFields.id] as int?,
    goalTime: json[UserFields.goalTime] as int,
    //description: json[UserFields.description] as String,
    //specials cases that need extra converting i.e bool and tim
    createdTime: DateTime.parse(json[UserFields.time] as String),
    isCompleted: json[UserFields.isCompleted] == 1,

  );


  // Map to allow data to be inserted into sql
  Map<String, Object?>toJson() => {
    //a map of key values
    UserFields.id: id,
    UserFields.goalTime: goalTime,
    //Bool and DateTime needs conversion before inserted into sql
    UserFields.isCompleted: isCompleted ? 1 : 0,
    //converts time to string
    UserFields.time: createdTime.toIso8601String(),
  };
}