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
  String _tableSync = 'sync';

  Future<Database> get dbInstance async {
    if (_dbInstance == null) {
      final path = await getDatabasesPath();
      _dbInstance = await openDatabase(
        '$path/$_databaseName',
        version: _dbVersion,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE $_tableName ($_tableId TEXT PRIMARY KEY,  $_tableTitle TEXT, $_tableDescription TEXT, $_tableSync INTEGER)');
        },
      );
    }
    return _dbInstance!;
  }

  Future<Todo> addNote(
      {String? id, required String title, required String description}) async {
    final db = await dbInstance;
    final dbPayload = {

      _tableId: id ?? Ulid().toUuid(),
      _tableTitle: title,
      _tableDescription: description,
      _tableSync: id != null ? 1 : 0
    };
    await db.insert(_tableName,dbPayload );
    return Todo.fromDbMap(dbPayload);
  }

  Future<List<Todo>> getNote() async {
    final db = await dbInstance;
    final response = await db.query(_tableName);
    return response.map((e) => Todo.fromDbMap(e)).toList();
  }

  Future<Todo> updateNote(
      {required String id,
      required String title,
      required String description,
      required bool sync,
      }) async {
    final db = await dbInstance;
    db.update(
        _tableName, {
      _tableTitle: title,
      _tableDescription: description,
      _tableSync: sync ? 1 : 0
    },
      where: '$_tableId = ?',
      whereArgs: [id],
    );
    return Todo(id: id, title: title, description: description);

  }

  Future<void> deleteNote(
      {required String id}) async {
    final db = await dbInstance;
    await db.delete(_tableName,where: '$_tableId = ?',whereArgs: [id]);
  }
  Future<void> clear() async{
    final db = await dbInstance;
    await db.delete(_tableName);
  }
  Future<List<Todo>> getNotSyncData() async{
    final db = await dbInstance;
    final res = await db.query(_tableName , where: '$_tableSync = ?',whereArgs: [0]);
    return res.map((e) => Todo.fromDbMap(e)).toList();
  }
}
