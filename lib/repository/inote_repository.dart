import 'package:dartz/dartz.dart';

import '../constants/todo.dart';

abstract class INoteRepository{
  Future<Either<String, List<Todo>>> fetchTodo();
  Future<Either<String, void>> addTodo({
    required String title,
    required String description,
  });

  Future<Either<String, void>> deleteTodo({required String id});

  Future<Either<String, void>> updateTodo({
    required String id,
    required String title,
    required String description,
  });

}


