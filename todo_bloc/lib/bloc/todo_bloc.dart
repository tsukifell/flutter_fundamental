import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial([])) {
    on<OnAddTodo>(addTodo);

    on<OnUpdateTodo>(updateTodo);

    on<OnRemoveTodo>(removeTodo);
  }

  FutureOr<void> removeTodo(event, emit) async {
    emit(TodoLoading(state.todos));
    Future.delayed(const Duration(milliseconds: 1500));
    int index = event.index;
    List<Todo> todosRemoved = state.todos;
    todosRemoved.removeAt(index);
    emit(TodoRemove(todosRemoved));
  }

  FutureOr<void> updateTodo(event, emit) async {
    emit(TodoLoading(state.todos));
    Future.delayed(const Duration(milliseconds: 1500));
    Todo newTodo = event.newTodo;
    int index = event.index;
    List<Todo> todosUpdated = state.todos;
    todosUpdated[index] = newTodo;
    emit(TodoUpdate(todosUpdated));
  }

  FutureOr<void> addTodo(event, emit) async {
    emit(TodoLoading(state.todos));
    Future.delayed(const Duration(milliseconds: 1500));
    Todo newTodo = event.newTodo;
    emit(TodoAdded([...state.todos, newTodo]));
  }
}
