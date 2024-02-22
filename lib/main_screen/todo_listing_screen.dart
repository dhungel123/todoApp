import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_list/cubit/common_state.dart';
import 'package:todo_list/cubit/delete_todo_cubit.dart';
import 'package:todo_list/cubit/fetch_todo_cubit.dart';
import 'package:todo_list/database/database_services.dart';

import '../Routes/routes.dart';
import '../constants/todo.dart';
import '../constants/urls.dart';

class TodoListingScreen extends StatefulWidget {
  const TodoListingScreen({super.key});

  @override
  State<TodoListingScreen> createState() => _TodoListingScreenState();
}

class _TodoListingScreenState extends State<TodoListingScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    context.read<FetchTodoCubit>().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            // final data = await DatabaseServices().getNotSyncData();
            // print(data);
            final result = await Connectivity().checkConnectivity();
            print('connection $result');
          }, icon: Icon(Icons.abc))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.createTodo);
        },
        child: Icon(Icons.add),
      ),
      body: BlocListener<DeleteTodoCubit, CommonState>(
        listener: (context, state) {
          if(state is CommonLoadingState){
            context.loaderOverlay.show();
          }else{
            context.loaderOverlay.hide();
          }
          if(state is CommonErrorState){
            Fluttertoast.showToast(msg: state.msg);
          }else if( state is CommonSuccessState){
            print('yo po chaliracha');
            Fluttertoast.showToast(msg: 'Note Deleted successfully');
          }

        },
        child: BlocBuilder<FetchTodoCubit, CommonState>(
            builder: (context, state) {
              if (state is CommonSuccessState<List<Todo>>) {
                if (state.data.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(motion: ScrollMotion(),
                            children:[
                              SlidableAction(onPressed: (context){
                                context.read<DeleteTodoCubit>()
                                    .deleteTodos(id: state.data[index].id);


                              },icon: Icons.delete,backgroundColor: Colors.red,foregroundColor: Colors.white,),
                              SlidableAction(onPressed: (context){
                                Navigator.of(context).pushNamed(Routes.createTodo,
                                    arguments: state.data[index]);
                              },icon: Icons.edit,backgroundColor: Colors.yellow,foregroundColor: Colors.white,)
                            ] ),
                        child: ListTile(
                          title: Text(
                            state.data[index].title,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            state.data[index].description,
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.createTodo,
                                arguments: state.data[index]);
                          },
                        ),
                      );
                    },
                    itemCount: state.data.length,
                  );
                } else {
                  return Center(
                    child: Text('No data found'),
                  );
                }
              } else if (state is CommonErrorState) {
                return Center(
                  child: Text(state.msg),
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }),
      ),
    );
  }
}
