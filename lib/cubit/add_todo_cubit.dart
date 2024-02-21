import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/add_todo_event.dart';
import 'package:todo_list/cubit/common_state.dart';

import '../repository/inote_repository.dart';
import '../repository/remote_note_repository.dart';

class AddTodoCubit extends Bloc<TodoEvent,CommonState> {
  final INoteRepository repository;

  AddTodoCubit({required this.repository}) : super(CommonInitialState()){
    on<AddTodoEvent>((event, emit) async{
      emit(CommonLoadingState());
        final res =
            await repository.addTodo(title: event.title, description: event.description);
        res.fold(
            (err) => emit(CommonErrorState(msg: err),),
            (data) => emit(CommonSuccessState(data: null)));
    },
      transformer: droppable()
    );
  }


}
