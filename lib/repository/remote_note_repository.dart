import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_list/database/database_services.dart';
import 'package:todo_list/repository/inote_repository.dart';

import '../constants/todo.dart';
import '../constants/urls.dart';

class RemoteNoteRepository implements INoteRepository {
  List<Todo> _todos = [];
  late final Todo todo;

  List<Todo> get todos => _todos;
  final dio = Dio();

  DatabaseServices databaseServices = DatabaseServices();



  @override
  Future<Either<String, List<Todo>>> fetchTodo() async {
    try {
      if (_todos.isNotEmpty) {
        return Right(_todos);
      }
      final response = await dio.get(Urls.notes);
      final convertedList = List.from(response.data['data']);
      final data = convertedList.map((e) => Todo.fromMap(e)).toList();
      _todos.clear();
      await databaseServices.clear();
      _todos.addAll(data);
      for( var _newTodo in _todos){
        await databaseServices.addNote(
            id:_newTodo.id,
            title: _newTodo.title,
            description: _newTodo.description,
        );

      }
      return Right(_todos);

    } on DioException catch (e) {
      if(e.error is SocketException){
        final dbData = await databaseServices.getNote();
        if(dbData.isNotEmpty){
          return Right(dbData);
        }
        return Left('Not connected to any network');
      } else {
        return Left(e.response?.data['message'] ?? 'Unable to fetch todo');
      }
    } catch (e) {
      return left(e.toString());
    }
  }
  @override
  Future<Either<String, void>> addTodo({
    required String title,
    required String description,
  }) async {
    try {
      final dio = Dio();
      final res = await dio.post(Urls.notes, data: {
        'title': title,
        'description': description,
      });
      final _newTodo = Todo.fromMap(res.data['data']);
      _todos.add(_newTodo);

      await databaseServices.addNote(
        id:_newTodo.id,
        title: _newTodo.title,
        description: _newTodo.description,
      );

      return Right(null);
    } on DioException catch (e) {
      if(e.error is SocketException){
        final res = await databaseServices.addNote(
          title: title,
          description: description,
        );
        _todos.add(res);
        return Right(null);
      }
      return Left(e.response?.data['message'] ?? 'Unable to fetch todo');

    } catch (e) {
      return left(e.toString());
    }
  }
    @override
    Future<Either<String, void>> deleteTodo({required String id})   async {
    try {
      final dio = Dio();
      final _ = await dio.delete(
        '${Urls.notes}/${id}',
      );
      _todos.removeWhere((e) => e.id == id);
      await databaseServices.deleteNote(id: id);
      return Right(null);

    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Unable to fetch todo');
    } catch (e) {
      return left(e.toString());
    }
  }
  @override
  Future<Either<String, void>> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.put(
        '${Urls.notes}/${id}',
        data: {
          'title':title,
          'description': description
        }
      );
    final _index =   _todos.indexWhere((e) =>e.id == id );
    if(_index != -1){
      _todos[_index] = Todo.fromMap(response.data['data']);
      await databaseServices.updateNote(id: id, title: title, description: description, sync: true);
    }
      return Right(null);
    } on DioException catch (e) {
      if(e.error is SocketException){
        final res = await databaseServices.updateNote(
          title: title,
          description: description,
          id: id,
          sync: false
        );
        final _index =   _todos.indexWhere((e) =>e.id == id );
        if(_index != -1){
          _todos[_index] = res;
        }
        return Right(null);
      }
      return Left(e.response?.data['message'] ?? 'Unable to fetch todo');
    } catch (e) {
      return left(e.toString());
    }
  }
  Future<Either<String ,void>> syncTodo() async{
    try{
      final dio = Dio();
      final _localTodo = await databaseServices.getNotSyncData();
      final _ = await dio.post(
        '${Urls.notes}/sync',
        data:
          {
          'todo':_localTodo.map((e) => e.toMap()).toList(),
      }
      );
databaseServices.clear();
_todos.clear();
return Right(null);

    }on DioException catch(e){
      return Left(e.response?.data['message']?? 'unable to sync');
    }
    catch(e){
      return Left(e.toString());

    }
  }
}

