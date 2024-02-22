import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_list/cubit/common_state.dart';
import 'package:todo_list/cubit/fetch_todo_cubit.dart';
import 'package:todo_list/cubit/upload_todo_cubit.dart';
import 'package:todo_list/repository/remote_note_repository.dart';
import 'package:todo_list/sync/db_sync.dart';

void showSyncDialog(BuildContext context) async{
  context.read<DbSyncCubit>().toogleDialogStatus(true);
  showDialog(
      context: context,
      barrierDismissible: false,
      builder:(context)=>BlocProvider(create: (context)=>UploadTodoCubit(
      repository: context.read<RemoteNoteRepository>(),
  ),
    child: SyncTodoDialog(),

  )
  );
}

class SyncTodoDialog extends StatelessWidget {
  const SyncTodoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        listener:(context,state){
          if(state is CommonLoadingState){
            context.loaderOverlay.show();
          }else{
            context.loaderOverlay.hide();
          }
          if( state is CommonSuccessState){
            context.read<DbSyncCubit>().toogleDialogStatus(false);
            context.read<FetchTodoCubit>().fetchTodos();
            Fluttertoast.showToast(msg: 'Database Synchronized Successfully');
            Navigator.pop(context);
          }else if(state is CommonErrorState){
            Fluttertoast.showToast(msg:state.msg);

          }
        },
      child: Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Unsynchronize data available'
              ),
              SizedBox(height: 10,),
              Text('You have unsynchronized data left',textAlign: TextAlign.center,),
              TextButton(onPressed: (){
                context.read<UploadTodoCubit>().sync();
              }, child: Text('Sync'))


            ],
          ),
        ),
      ),
    );
  }
}
