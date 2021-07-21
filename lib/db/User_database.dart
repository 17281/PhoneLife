import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:sqflite/sqflite.dart';


class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async{
    //the database will ONLY (if _initDB != exist) be created if the database return is null (which will always be null upon download
    if (_database != null) return _database!;
    _database = await _initDB('Goal.db');
    return _database!;
  }
  //finds the path for the database on Android and IOS
  Future<Database> _initDB(String filepath) async {
    //if database is stored in different location, then use "path_provider"
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    //opens database file with its pathway
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //create database table
  Future _createDB(Database db, int version) async {
    //Type of field in sql
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';

    //creates the table based on the model table listed before
    await db.execute(''' CREATE TABLE $userTable (
    ${UserFields.id} $idType, 
    ${UserFields.isImportant} $boolType, 
    ${UserFields.name} $textType,
    ${UserFields.time} $textType
    )''');
  }


  //Users adding things to 'Note' table
  Future<UserContent> create(UserContent content) async {
  //reference to database
    final db = await instance.database;
    //passing sql statements
    ///final id = await db
      ///.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //insert into selected      table       data-selected
    final id = await db.insert(userTable, content.toJson());
    //object modified is id in this case
  return content.copy(id: id);

  }

  //adding data into sql with statements
  Future<UserContent> readGoal(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      userTable,
      columns: UserFields.values,
      ///using ? instead of $id as it stops sql injections
      where: '${UserFields.id} = ?',
      ///adding values [id, values] then add = '? ?' etc
      whereArgs: [id],
    );


    //if maps exists, run map
    if (maps.isNotEmpty) {
      //converts note into Json object for the first item
      return UserContent.fromJson(maps.first);
    }//If item can't be found
    else {
      throw Exception('ID $id not found');
    }
}

  //Reading multiple data at a time
  Future<List<UserContent>> readAllGoals() async {
    final db =await instance.database;
    //database table and table could be changed

    ///   Sorts data by time      ASC == asending order
    final orderBy = '${UserFields.time} ASC';
    //final result =
    //this allows raw sql query to be used *Very NICE
        ///await db.rawQuery('SELECT * FROM $UserFields ORDER BY $orderBy');
    final result = await db.query(userTable, orderBy: orderBy);
    //Convert json string to sql
    return result.map((json)=> UserContent.fromJson(json)).toList();
  }

  //updates our data
  Future<int> update(UserContent content) async {
    final db = await instance.database;
    ///if you want to use raw sql statements; use db.rawUpdate
    return db.update(
      userTable,
      content.toJson(),

      //defining which data you want to update
      where: '${UserFields.id} = ?',
      whereArgs: [content.id],

    );
  }

  //Deleting data
  Future<int> delete(int id) async {
    final db = await instance.database;
    //finding which data to delete from a defined id
    return await db.delete(
      userTable,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }
  //Closing database
  Future closeDB() async{
    final db = await instance.database;

    //Finds the database then closes it
    db.close();
  }
}

///Screen time Database ----------------------------------------------------------------------------
class ScreenTimeDatabase {
  static final ScreenTimeDatabase instance = ScreenTimeDatabase._int();
  static Database? _STDatabase;
  ScreenTimeDatabase._int();


  Future<Database> get database async{
    //the database will ONLY be created if the database return is null (which will always be null upon download)
    if (_STDatabase != null) return _STDatabase!;
    //creates Screen time database
    _STDatabase = await _initScreenTimeDB('ScreenTime.db');
    return _STDatabase!;
  }

  //initializing path of database
Future<Database> _initScreenTimeDB(String filepath ) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filepath);

return await openDatabase(path, version: 1, onCreate: _createScreenTimeDB);
}

}

Future _createScreenTimeDB(Database db, int version) async {
  //Type of field in sql
  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final stringType = 'STRING NOT NULL';
  final textType = 'TEXT NOT NULL';

  //creates the table based on the model table listed before
  await db.execute(''' CREATE TABLE $ScreenTimeTable (
    ${STFields.id} $idType, 
    ${STFields.text} $textType,
    ${STFields.time} $stringType
    )''');


}