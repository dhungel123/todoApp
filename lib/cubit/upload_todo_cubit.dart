import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/common_state.dart';

import '../repository/remote_note_repository.dart';

class UploadTodoCubit extends Cubit<CommonState> {
  final RemoteNoteRepository repository;
  UploadTodoCubit({required this. repository}) : super(CommonInitialState());

  sync() async{
    emit(CommonLoadingState());
    final res =  await  repository.syncTodo();
    res.fold((err) => emit(CommonErrorState(msg: err)), (r) => emit(CommonSuccessState(data: null)));


  }
}
