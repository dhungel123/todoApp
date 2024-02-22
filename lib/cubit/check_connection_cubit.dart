

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppConnection {
  Connected,
  NotConnected
}
class CheckConnectionCubit extends Cubit<AppConnection> {
  StreamSubscription? internetSubscription ;




  CheckConnectionCubit() : super(AppConnection.Connected){
    final result = Connectivity().checkConnectivity().then((event) {
      if(event == ConnectivityResult.none){
        emit(AppConnection.NotConnected);
      }else{
        emit(AppConnection.Connected);
      }

    });
    internetSubscription  = Connectivity().onConnectivityChanged.listen((event) {
      print(event);
      if(event == ConnectivityResult.none){
        emit(AppConnection.NotConnected);
      }else{
        emit(AppConnection.Connected);
      }

    });

  }
}
