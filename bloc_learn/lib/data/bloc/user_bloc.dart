import 'package:bloc_learn/data/model/user.dart';
import 'package:bloc_learn/data/source/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;
  UserBloc(this.apiService) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await apiService.getUsers();
        emit(UserLoaded(result.data));
      } catch (exception) {
        emit(UserError(exception.toString()));
      }
    });
  }
}
