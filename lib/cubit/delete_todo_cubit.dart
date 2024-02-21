import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/common_state.dart';
import '../repository/inote_repository.dart';
import '../repository/remote_note_repository.dart';

class DeleteTodoCubit extends Cubit<CommonState> {
  final INoteRepository repo;

  DeleteTodoCubit({required this.repo}) : super(CommonInitialState());

  deleteTodos({required String id}) async {
    emit(CommonLoadingState());
    final res = await repo.deleteTodo(id: id);
    res.fold(
            (err) => emit(
          CommonErrorState(msg: err),
        ),
            (data) => emit(CommonSuccessState(data: null)));
  }
}
