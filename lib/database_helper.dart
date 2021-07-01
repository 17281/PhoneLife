import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  //initalize database objects
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _tableName = 'myTable';

  static final columnId = '_id';
  static final columnName = 'name';
  //making it a singleton class
  DatabaseHelper._privateConstructor();

  //one instance of database_helper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    //if database not Null
    if(_database != null) return _database;
    //if database not exists
    _database = await _initDatabase();
    return _database;
  }

  //creating the database if it does not exist
  _initDatabase () async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    //when database is created, joins path and database function
    return await openDatabase(path,version: _dbVersion, onCreate: _onCreate);

  }
  //creating database table using sql statements
  Future _onCreate(Database db, int version) {
    //sql query
    db.query(
      '''
      CREATE TABLE $_tableName (
      $columnId INTEGER PRIMARY KEY, 
      $columnName TEXT NOT NULL)
      
      '''
    );
}
  // adding maps to insert objects into database      Flutter SQFlite, easy beginers tutorial
Future<int> insert(Map<String,dynamic> row) async {
    //in case the database is removed, recall to init database
    Database db = await instance.database;
    return await db.insert(_tableName, row);
}

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db = await instance.database;
    //returns all rows present on the table
    return await db.query(_tableName);
  }

//updating values/goals
  Future update(Map<String,dynamic> row) async {
    Database db = await instance.database;
    //for a specific row, the column is changed based on id
    int id = row[columnId];
    //returns number of rows updated
    return await db.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //delete command
Future<int> delete (int id) async {
    //Ensuring database connections
  Database db = await instance.database;
  //delete column where column id = selected id
  return await db.delete(_tableName, where:'$columnId = ?', whereArgs: [id]);
}
}