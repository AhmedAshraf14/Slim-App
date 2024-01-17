import 'package:sqflite/sqflite.dart'; // sqflite for database
import 'package:path/path.dart'; // the path package
import 'package:slim/models/breakfast_model.dart';
class DatabaseConnect {
  Database? _database;

  Future<Database> get database async {
    // this is the location of our database in device. ex - data/data/....
    final dbpath = await getDatabasesPath();
    // this is the name of our database.
    const dbname = 'breakfast.db';
    // this joins the dbpath and dbname and creates a full path for database.
    // ex - data/data/todo.db
    final path = join(dbpath, dbname);

    // open the connection
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    // we will create the _createDB function separately

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    // make sure the columns we create in our table match the todo_model field.
    await db.execute('''
      CREATE TABLE breakfast(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        creationDate TEXT,
        isChecked INTEGER
      )
    ''');
  }

  Future<void> insertbreakfast(BreakFast breakfast) async {
    // get the connection to database
    final db = await database;
    // insert the todo
    await db.insert(
      'breakfast', // the name of our table
      breakfast.toMap(), // the function we created in our todo_model
      conflictAlgorithm:
      ConflictAlgorithm.replace, // this will replace the duplicate entry
    );
  }

  Future<void> deletebreakfast(BreakFast breakfast) async {
    final db = await database;
    // delete the todo from database based on its id.
    await db.delete(
      'breakfast',
      where: 'id == ?', // this condition will check for id in todo list
      whereArgs: [breakfast.id],
    );
  }

  Future<List<BreakFast>> getBreakFast() async {
    final db = await database;
    // query the database and save the todo as list of maps
    List<Map<String, dynamic>> items = await db.query(
      'breakfast',
      orderBy: 'id DESC',
    ); // this will order the list by id in descending order.
    // so the latest todo will be displayed on top.

    // now convert the items from list of maps to list of todo

    return List.generate(
      items.length,
          (i) =>
          BreakFast(
            id: items[i]['id'],
            title: items[i]['title'],
            creationDate: DateTime.parse(items[i][
            'creationDate']),
            // this is in Text format right now. let's convert it to dateTime format
            isChecked: items[i]['isChecked'] == 1
                ? true
                : false, // this will convert the Integer to boolean. 1 = true, 0 = false.
          ),
    );
  }
}