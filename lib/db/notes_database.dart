import 'package:path/path.dart';
import 'package:phoneapp/model/note.dart';
import 'package:sqflite/sqflite.dart';


class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async{
    //the database will ONLY (if _initDB != exist) be created if the database return is null (which will always be null upon download
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
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
    final boolType = 'BOOLEAN NOT NULL';
    final stringType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    //creates the table based on the model table listed before
    await db.execute(''' CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType, 
    ${NoteFields.isImportant} $boolType, 
    ${NoteFields.number} $stringType, 
    ${NoteFields.description} $textType,
    ${NoteFields.title} $textType,
    ${NoteFields.time} $textType
    )''');
  }


  //Users adding things to 'Note' table
  Future<Note> create(Note note) async {
  //reference to database
    final db = await instance.database;

    final json = note.toJson();
    //column name
    final columns =
        '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    //value for inserting by sql statement
    final values =
        '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';

    //passing sql statements
    ///final id = await db
      ///.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //insert into selected      table       data-selected
    final id = await db.insert(tableNotes, note.toJson());

    //object modified is id in this case
  return note.copy(id: id);

  }

  //adding data into sql with statements
  Future<Note> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      ///using ? instead of $id as it stops sql injections
      where: '${NoteFields.id} = ?',
      ///adding values [id, values] then add = '? ?' etc
      whereArgs: [id],
    );

    //if maps exists, run map
    if (maps.isNotEmpty) {
      //converts note into Json object for the first item
      return Note.fromJson(maps.first);
    }//If item can't be found
    else {
      throw Exception('ID $id not found');
    }
}

  //Reading multiple data at a time
  Future<List<Note>> readAllNotes() async {
    final db =await instance.database;
    //database table (tableNotes) could be changed

    ///   Sorts data by time      ASC == asending order
    final orderBy = '${NoteFields.time} ASC';
    //final result =
    //this allows raw sql query to be used *Very NICE
        ///await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    ///                          tableNotes, 'Sql where statement can be inserted and changed
    final result = await db.query(tableNotes, orderBy: orderBy);
    //Convert json string to sql
    return result.map((json)=> Note.fromJson(json)).toList();
  }

  //updates our data
  Future<int> update(Note note) async {
    final db = await instance.database;
    ///if you want to use raw sql statements; use db.rawUpdate
    return db.update(
      tableNotes,
      note.toJson(),

      //defining which data you want to update
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],

    );
  }

  //Deleting data
  Future<int> delete(int id) async {
    final db = await instance.database;
    //finding which data to delete from a defined id
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
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


