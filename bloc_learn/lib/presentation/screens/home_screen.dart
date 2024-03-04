import 'package:bloc_learn/data/bloc/user_bloc.dart';
import 'package:bloc_learn/data/source/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(ApiService())..add(LoadUser()),
      child: Scaffold(
          appBar: AppBar(title: const Text('Users')),
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                final data = state.users;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(data[index].avatar)),
                        title: Text(
                            '${data[index].firstName} ${data[index].lastName}'),
                        subtitle: Text(data[index].email),
                      );
                    });
              } else if (state is UserError) {
                return Center(child: Text(state.error));
              }
              return const SizedBox();
            },
          )),
    );
  }
}
