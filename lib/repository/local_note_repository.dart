import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/constants/todo.dart';
import 'package:todo_list/database/database_services.dart';
import 'package:todo_list/repository/inote_repository.dart';

class LocalNoteRepository implements INoteRepository{
  final databaseServices = DatabaseServices();



  @override
  Future<Either<String, void>> addTodo({required String title, required String description}) async {
    await databaseServices.addNote(title: title, description: description);
    return Right(null);
  }

  @override
  Future<Either<String, void>> deleteTodo({required String id})  async{
    await databaseServices.deleteNote(id: id);
    return Right(null);
  }

  @override
  Future<Either<String, List<Todo>>> fetchTodo()async {
    final res =  await databaseServices.getNote();
    return Right(res);

  }

  @override
  Future<Either<String, void>> updateTodo({required String id, required String title, required String description})  async{
    await databaseServices.updateNote(id:id, title: title, description: description, sync: false);
    return Right(null);


  }
}
