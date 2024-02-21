import 'package:sqflite/sqflite.dart';
import 'package:ulid/ulid.dart';

import '../constants/todo.dart';

class DatabaseServices {
  Database? _dbInstance;

  String _databaseName = 'note.db';
  int _dbVersion = 1;
  String _tableName = 'note';
  String _tableDescription = 'description';
  String _tableId = 'id';
  String _tableTitle = 'title';

  Future<Database> get dbInstance async {
    if (_dbInstance == null) {
      final path = await getDatabasesPath();
      _dbInstance = await openDatabase(
        '$path/$_databaseName',
        version: _dbVersion,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE $_tableName ($_tableId TEXT PRIMARY KEY,  $_tableTitle TEXT, $_tableDescription TEXT)');
        },
      );
    }
    return _dbInstance!;
  }

  Future<void> addNote(
      { required String title, required String description}) async {
    final db = await dbInstance;
    await db.insert(_tableName, {
      _tableId: Ulid().toUuid(),
      _tableTitle: title,
      _tableDescription: description,
    });
  }

  Future<List<Todo>> getNote() async {
    final db = await dbInstance;
    final response = await db.query(_tableName);
    return response.map((e) => Todo.fromDbMap(e)).toList();
  }

  Future<void> updateNote(
      {required String id,
      required String title,
      required String description}) async {
    final db = await dbInstance;
    db.update(
        _tableName, {
      _tableTitle: title,
      _tableDescription: description,
    },
      where: '$_tableId = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(
      {required String id}) async {
    final db = await dbInstance;
    await db.delete(_tableName,where: '$_tableId = ?',whereArgs: [id]);
  }
}
