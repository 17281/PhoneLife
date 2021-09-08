import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:phoneapp/model/Goals.dart';
import 'package:phoneapp/model/ScreenTime.dart';
import 'package:phoneapp/model/DiffTime.dart';
import 'package:sqflite/sqflite.dart';

class DiffTimeDatabase {
  static final DiffTimeDatabase instance = DiffTimeDatabase._init();
  static Database? _diffGoalDatabase;

  DiffTimeDatabase._init();


  Future<Database> get database async{
    //the database will ONLY (if _initDB != exist) be created if the database return is null (which will always be null upon download
    if (_diffGoalDatabase != null) return _diffGoalDatabase!;
    _diffGoalDatabase = await _initDB('diffGoal.db');
    return _diffGoalDatabase!;
  }


  //finds the path for the database on Android and IOS
  Future<Database> _initDB(String filepath) async {
    //if database is stored in different location, then use "path_provider"
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    //TODO: Remove for final development
    await deleteDatabase(path);
    //opens database file with its pathway
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //create database table
  Future _createDB(Database db, int version) async {
    //Type of field in sql
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    final intType = 'INT NOT NULL';

    //creates the table based on the model table listed before
    await db.execute(''' CREATE TABLE $diffGoal (
    ${GoalFields.id} $idType, 
    ${GoalFields.isDiffComplete} $boolType, 
    ${GoalFields.goalDiff} $intType,
    ${GoalFields.time} $textType
    )''');
  }

  //Users adding things to 'User' table
  Future<GoalContent> create(GoalContent content) async {
    //reference to database
    final db = await instance.database;
    //passing sql statements
    //insert into selected      table           data-selected
    final goalId = await db.insert(diffGoal, content.toJson());
    return content.copy(id: goalId);
  }

  //adding data into sql with statements
  Future<GoalContent> readGoal(int id) async{
    final db = await instance.database;
    final maps = await db.query(
      diffGoal,
      columns: GoalFields.values,
      ///using ? instead of $id as it stops sql injections
      where: '${GoalFields.id} = ?',
      ///adding values [id, values] then add = '? ?' etc
      whereArgs: [id],
    );

    //if maps exists, run map
    if (maps.isNotEmpty) {
      print(maps);
      //converts note into Json object for the first item
      return GoalContent.fromJson(maps.first);
    }//If item can't be found
    else {
      throw Exception('ID $id not found');
    }
  }
}



  class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  static late int goalID;
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
    //TODO: Remove for final development
    await deleteDatabase(path);
    //opens database file with its pathway
    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  //create database table
  Future _createDB(Database db, int version) async {
    //Type of field in sql
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    final intType = 'INT NOT NULL';

    //creates the table based on the model table listed before
    await db.execute(''' CREATE TABLE $userTable (
    ${UserFields.id} $idType, 
    ${UserFields.isCompleted} $boolType, 
    ${UserFields.goalTime} $intType,
    ${UserFields.time} $textType
    )''');
  }

  //Users adding things to 'User' table
  Future<UserContent> create(UserContent content) async {
  //reference to database
    final db = await instance.database;
    //passing sql statements
    //insert into selected      table           data-selected
    final goalId = await db.insert(userTable, content.toJson());
    goalID = goalId;
  return content.copy(id: goalId);
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
      print(maps);
      //converts note into Json object for the first item
      return UserContent.fromJson(maps.first);
    }//If item can't be found
    else {
      throw Exception('ID $id not found');
    }
}

  //Reading multiple data at a time
  Future<List<UserContent>> readAllGoals() async {
    final db = await instance.database;
    ///   Sorts data by time
    final orderBy = '${UserFields.id} DESC';
    ///await db.query(userTable, orderBy: orderBy);
    final results = await db.rawQuery('SELECT * FROM $userTable ORDER BY $orderBy');
    //Convert json string to sql
    print (results);
    return results.map((json)=> UserContent.fromJson(json)).toList();
  }

  Future<int?>countCompletedGoals() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $userTable WHERE isCompleted = TRUE'));
    return count;
  }

  Future<int?>countUnCompletedGoals() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $userTable WHERE isCompleted = False')
    );
    return count;
  }

  //updates our data
  Future<int> update(UserContent content) async {
    final db = await database;
    ///if you want to use raw sql statements; use db.rawUpdate
    return db.update(
      userTable,
      content.toJson(),
      //defining which data you want to update
      where: '${UserFields.id} = ?', whereArgs: [content.id],
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
  static late int finalTime;
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
   ///TODO: REMOVE THE CODE BELOW FOR FINAL PRODUCTION
    await deleteDatabase(path);
  //version of database
  return await openDatabase(path, version: 3, onCreate: _createScreenTimeDB);
  }

  Future _createScreenTimeDB(Database db, int version) async {
    //Type of field in sql
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'STRING NOT NULL';
    final textType = 'TEXT NOT NULL';

    //creates the table based on the model table listed before
    await db.execute(''' CREATE TABLE $screenTimeTable (
      ${STFields.ST_id} $idType, 
      ${STFields.startTime} $textType,
      ${STFields.stopTime} $textType,
      ${STFields.diffTime} $stringType,
      ${STFields.createdTime} $textType
      )'''
    );
  }

//Users adding screen time/contents
  Future<ScreenContents> createST(ScreenContents content) async {
    //reference to database
    final db = await instance.database;
    //Adds ST_contents to json and then passed back
    final ST_id = await db.insert(screenTimeTable, content.toJson());
    //objects modified is where id = id
    return content.copy(ST_id: ST_id);
  }

  Future findTotalTime() async {
    final db = await instance.database;
    final orderBy1 = '${STFields.ST_id} ASC';
    final orderBy2 = '${STFields.ST_id} DESC';
    String dateToday = DateFormat.yMd().format(DateTime.now()).toString();

    final startTimeResults = await db.rawQuery('SELECT startTime FROM $screenTimeTable WHERE createdTime = "$dateToday" ORDER BY $orderBy1 LIMIT 1');
    final stopTimeResults = await db.rawQuery('SELECT stopTime FROM $screenTimeTable WHERE createdTime = "$dateToday" ORDER BY $orderBy2 LIMIT 1');

    print(startTimeResults);
    //converting string to datetime variables
    final startTimeResult = DateTime.parse(startTimeResults[0]['startTime'].toString());
    final stopTimeResult = DateTime.parse(stopTimeResults[0]['stopTime'].toString());

    print ('$stopTimeResult and $startTimeResult');
    //calculates the difference between start and stop
    Duration totalTime = stopTimeResult.difference(startTimeResult);
    finalTime = totalTime.inSeconds.round();
    return totalTime;
  }

  //adding data into sql with statements
  Future<ScreenContents> readScreenTime(int ST_id) async {
    final db = await instance.database;
  //selecting a single content to display where id = ?
    final maps = await db.query(
      screenTimeTable,
      columns: STFields.values,
      ///using ? instead of $id as it stops sql injections
      where: '${STFields.ST_id} = ?',
      whereArgs: [ST_id],
    );

    //if maps exists, run map
    if (maps.isNotEmpty) {
      //converts note into Json object for the first item
      return ScreenContents.fromJson(maps.first);
    } //If item can't be found
    else {
      throw Exception('No data found $ST_id');
    }

  }

  //read all content then list them
  Future<List<ScreenContents>> readAllTime() async {
    final db = await instance.database;
    ///   Sorts data by time      ASC == asending order
    final orderBy = '${STFields.startTime} ASC';
    final result = await db.query(screenTimeTable, orderBy: orderBy);
    print (result);
    //Convert json string to sql
    return result.map((json)=> ScreenContents.fromJson(json)).toList();
  }

  //updates our data
  Future<int> updateST(ScreenContents content) async {
    final db = await instance.database;
    return db.update(
      screenTimeTable,
      content.toJson(),

      //defining which data you want to update
      where: '${STFields.ST_id} = ?',
      whereArgs: [content.ST_id],
    );
}

  Future closeSTDB() async{
    final db = await instance.database;
    //Finds the database then closes it
    db.close();
  }
}
