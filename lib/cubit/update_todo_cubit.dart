import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/common_state.dart';

import '../repository/inote_repository.dart';
import '../repository/remote_note_repository.dart';

class UpdateTodoCubit extends Cubit<CommonState> {
  final INoteRepository repository;

  UpdateTodoCubit({required this.repository}) : super(CommonInitialState());

  updateTodo(
      {required String id,
      required String title,
      required String description}) async {
    emit(CommonLoadingState());
    final res = await repository.updateTodo(
        title: title,
        description: description,
        id: id);
    res.fold(
        (err) => emit(
              CommonErrorState(msg: err),
            ),
        (data) => emit(CommonSuccessState(data: null)));
  }
}
