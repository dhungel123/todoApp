import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_list/Widgets/custom_text_field.dart';
import 'package:todo_list/constants/todo.dart';
import 'package:todo_list/cubit/add_todo_cubit.dart';
import 'package:todo_list/cubit/add_todo_event.dart';
import 'package:todo_list/cubit/common_state.dart';
import 'package:todo_list/cubit/delete_todo_cubit.dart';
import 'package:todo_list/cubit/fetch_todo_cubit.dart';
import 'package:todo_list/cubit/update_todo_cubit.dart';

class CreateTodo extends StatefulWidget {
  final Todo? todo;

  const CreateTodo({super.key, this.todo});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();

    return Scaffold(
      body: Center(
        child: MultiBlocListener(
          listeners: [
            BlocListener<DeleteTodoCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonLoadingState) {
                  context.loaderOverlay.show();
                } else {
                  context.loaderOverlay.hide();
                }
                if (state is CommonSuccessState) {
                  Fluttertoast.showToast(msg: 'Note delete successfully');
                  context.read<FetchTodoCubit>().fetchTodos();
                  Navigator.of(context).pop();
                } else if (state is CommonErrorState) {
                  Fluttertoast.showToast(msg: state.msg);
                }
              },
            ),

            BlocListener<AddTodoCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonLoadingState) {
                  context.loaderOverlay.show();
                } else {
                  context.loaderOverlay.hide();
                }
                if (state is CommonSuccessState) {
                  Fluttertoast.showToast(msg: 'Note added successfully');
                  context.read<FetchTodoCubit>().fetchTodos();
                  Navigator.of(context).pop();
                } else if (state is CommonErrorState) {
                  Fluttertoast.showToast(msg: state.msg);
                }
              },
            ),
            BlocListener<UpdateTodoCubit, CommonState>(
              listener: (context, state) {
                if (state is CommonLoadingState) {
                  context.loaderOverlay.show();
                } else {
                  context.loaderOverlay.hide();
                }
                if (state is CommonSuccessState) {
                  Fluttertoast.showToast(msg: 'Note updated successfully');
                  context.read<FetchTodoCubit>().fetchTodos();
                  Navigator.of(context).pop();
                } else if (state is CommonErrorState) {
                  Fluttertoast.showToast(msg: state.msg);
                }

              },
            ),
          ],
          child: FormBuilder(
            key: _key,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    label: 'Title',
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Password should not be empty";
                      } else if (value.length < 10) {
                        return 'Password should be less than 10';
                      } else {
                        return null;
                      }
                    },
                    name: 'title',
                    initialValue: widget.todo?.title,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                      label: 'Description',
                      initialValue: widget.todo?.description,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Password should not be empty";
                        } else if (value.length < 10) {
                          return 'Password should be less than 10';
                        } else {
                          return null;
                        }
                      },
                      name: 'desc'),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.saveAndValidate()) {
                        if (widget.todo != null) {
                          print('ya samma ayo');
                          context.read<UpdateTodoCubit>().updateTodo(
                              title: _key.currentState!.value['title'],
                              description: _key.currentState!.value['desc'],
                              id: widget.todo!.id);
                        } else {
                          // context.read<AddTodoCubit>().addTodo(
                          //     title: _key.currentState!.value['title'],
                          //     description: _key.currentState!.value['desc']);
                          context.read<AddTodoCubit>().add(AddTodoEvent(
                              title:_key.currentState!.value['title'],
                              description:_key.currentState!.value['desc']),
                          );
                        }
                      }
                    },
                    child: Text(widget.todo != null ? 'update' : 'Save'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
