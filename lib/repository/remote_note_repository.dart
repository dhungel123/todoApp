import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_list/repository/inote_repository.dart';

import '../constants/todo.dart';
import '../constants/urls.dart';

class RemoteNoteRepository implements INoteRepository {
  List<Todo> _todos = [];
  late final Todo todo;

  List<Todo> get todos => _todos;
  final dio = Dio();
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
      _todos.addAll(data);

      return Right(_todos);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Unable to fetch todo');
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

      return Right(null);
    } on DioException catch (e) {
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
    }
      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Unable to fetch todo');
    } catch (e) {
      return left(e.toString());
    }
  }
}
