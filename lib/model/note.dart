//Name of table created , This part is basically SQA
final String tableNotes = 'notes';

//contents created in SQL
class NoteFields {
  static final List<String> values = [
    ///add all fields
    id, isImportant, number, title, description,time
  ];


  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}


//Contents of table in flutter
class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;


  const Note ({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
});

  //copies note objects and changes items within database
  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,

}) =>
  Note(
    id: id ?? this.id,
    isImportant: isImportant ?? this.isImportant,
    number: number ?? this.number,
    title: title ?? this.title,
    description: description ?? this.description,
    createdTime: createdTime ?? this.createdTime,
  );

  // Map to allow data to be inserted into sql
  Map<String, Object?>toJson() => {
    //a map of key values
    //Table name:Key:corrisponding value
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.description: description,
    NoteFields.number: number,

    //Bool and DateTime needs conversion before inserted into sql
    NoteFields.isImportant: isImportant ? 1 : 0,

    //converts time to string
    NoteFields.time: createdTime.toIso8601String(),
  };
}