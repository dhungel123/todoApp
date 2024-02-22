import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/check_connection_cubit.dart';
import 'package:todo_list/cubit/common_state.dart';
import 'package:todo_list/database/database_services.dart';

class DbSyncCubit extends Cubit<CommonState>{
  final CheckConnectionCubit checkConnectionCubit;
  StreamSubscription? checkConnectionSubscription;

  bool isDialogShowed = false;

  DatabaseServices databaseServices = DatabaseServices();

  DbSyncCubit({required this.checkConnectionCubit}):super(CommonInitialState()){
    checkConnectionSubscription =
        checkConnectionCubit.stream.listen((event) async {
          if(event == AppConnection.Connected && isDialogShowed == false){
             final data = await databaseServices.getNotSyncData();
             if(data.isNotEmpty){
               emit(CommonLoadingState());
               emit(CommonSuccessState(data: null));
             }
          }

        });
  }
  toogleDialogStatus(bool status){
    isDialogShowed = status;
  }
  @override
  Future<void> close(){
    checkConnectionSubscription?.cancel();
    return super.close();

  }

}