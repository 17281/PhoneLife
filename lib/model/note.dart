//Name of table created , This part is basically SQA
import 'package:sqflite/sqflite.dart';

final String userTable = 'User';

//contents created in SQL
class UserFields {
  static final List<String> values = [
    ///add all fields
    id, isImportant, name,time
  ];


  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String name = 'name';
  static final String time = 'time';
}


//Contents of table in flutter
class UserContent {
  final int? id;
  final bool isImportant;
  final String name;
  final DateTime createdTime;


  //constructs users table contents
  const UserContent ({
    this.id,
    required this.isImportant,
    required this.name,
    required this.createdTime,
});

  //copies note objects and changes items within database
  UserContent copy({
    //primary key for id
    int? id,
    bool? isImportant,
    String? name,
    DateTime? createdTime,

}) =>
  UserContent(
    //setting type to the listed contents
    id: id ?? this.id,
    isImportant: isImportant ?? this.isImportant,
    name: name ?? this.name,
    createdTime: createdTime ?? this.createdTime,
  );

  //converting map fields into json (for data inserting)
  static UserContent fromJson(Map<String, Object?> json) => UserContent(
    id: json[UserFields.id] as int?,
    name: json[UserFields.name] as String,

    //specials cases that need extra converting i.e bool and tim
    createdTime: DateTime.parse(json[UserFields.time] as String),
    isImportant: json[UserFields.isImportant] == 1,

  );


  // Map to allow data to be inserted into sql
  Map<String, Object?>toJson() => {
    //a map of key values
    //Table name:Key:corrisponding value
    UserFields.id: id,
    UserFields.name: name,

    //Bool and DateTime needs conversion before inserted into sql
    UserFields.isImportant: isImportant ? 1 : 0,

    //converts time to string
    UserFields.time: createdTime.toIso8601String(),
  };
}