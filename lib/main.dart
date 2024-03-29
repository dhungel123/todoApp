import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_list/cubit/add_todo_cubit.dart';
import 'package:todo_list/cubit/check_connection_cubit.dart';
import 'package:todo_list/cubit/delete_todo_cubit.dart';
import 'package:todo_list/cubit/fetch_todo_cubit.dart';
import 'package:todo_list/cubit/update_todo_cubit.dart';
import 'package:todo_list/cubit/upload_todo_cubit.dart';
import 'package:todo_list/main_screen/todo_listing_screen.dart';
import 'package:todo_list/navigation/create_todo.dart';
import 'package:todo_list/navigation/invalid_screen.dart';
import 'package:todo_list/repository/inote_repository.dart';
import 'package:todo_list/repository/local_note_repository.dart';
import 'package:todo_list/repository/remote_note_repository.dart';
import 'package:todo_list/sync/db_sync.dart';

import 'Routes/routes.dart';
import 'constants/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => RemoteNoteRepository(),
          ),
          RepositoryProvider(
            create: (context) => LocalNoteRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false,
                create:(_) =>  CheckConnectionCubit()),
            BlocProvider(
                create: (context)=> DbSyncCubit(
                    checkConnectionCubit: context.read<CheckConnectionCubit>()),
            ),
            BlocProvider(
              create: (context) =>
                  DeleteTodoCubit(repo: context.read<RemoteNoteRepository>()),
            ),
            BlocProvider(
              create: (context) =>  FetchTodoCubit(
                  repo: context.read<RemoteNoteRepository>(),
                  deleteTodoCubit: context.read<DeleteTodoCubit>()) ,
            ),
            BlocProvider(
              create: (context) =>AddTodoCubit(
                  repository: context.read<RemoteNoteRepository>())
            ),
            BlocProvider(
             create: (context) => UpdateTodoCubit(
                repository: context.read<RemoteNoteRepository>())
            ),
          ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: (settings) {
                    if (settings.name == Routes.home) {
                      return PageTransition(
                          child: TodoListingScreen(),
                          type: PageTransitionType.fade);
                    } else if (settings.name == Routes.createTodo) {
                      return PageTransition(
                        child: CreateTodo(
                          todo: settings.arguments as Todo?,
                        ),
                        settings: settings,
                        type: PageTransitionType.fade,
                      );
                    } else {
                      return PageTransition(
                          child: InvalidScreen(),
                          type: PageTransitionType.fade);
                    }
                  },
                ),

            ),
          ),
    );
  }
}
