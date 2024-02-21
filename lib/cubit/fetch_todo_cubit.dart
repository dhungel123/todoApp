import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/common_state.dart';
import '../repository/inote_repository.dart';
import '../repository/remote_note_repository.dart';
import 'delete_todo_cubit.dart';

class FetchTodoCubit extends Cubit<CommonState> {
  final INoteRepository repo;
  DeleteTodoCubit deleteTodoCubit;
  StreamSubscription? deleteTodoSubscription;

  FetchTodoCubit({required this.repo,required this.deleteTodoCubit})
      : super(CommonInitialState()){
    deleteTodoSubscription = deleteTodoCubit.stream.listen((event) {
      if(event is CommonSuccessState){
        fetchTodos();
      }

    });
  }

  fetchTodos() async {
    emit(CommonLoadingState());
    final res = await repo.fetchTodo();
    res.fold(
        (err) => emit(
              CommonErrorState(msg: err),
            ),
        (data) => emit(CommonSuccessState(data: data)));
  }
  @override
  Future<void> close() {
    deleteTodoSubscription?.cancel();
    return super.close();
  }

}
