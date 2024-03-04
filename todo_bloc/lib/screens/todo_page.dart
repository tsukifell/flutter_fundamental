import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/todo_bloc.dart';
import 'package:todo_bloc/components/todo_input.dart';
import 'package:todo_bloc/models/todo.dart';
import 'package:d_info/d_info.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  addTodo() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          children: [
            TodoInput(
              titleController: titleController,
              descriptionController: descriptionController,
              onTap: () {
                Todo newTodo = Todo(
                  titleController.text,
                  descriptionController.text,
                );
                context.read<TodoBloc>().add(OnAddTodo(newTodo));
                Navigator.pop(context);
                DInfo.snackBarSuccess(context, 'Todo Successfully Added!');
              },
              actionTitle: 'Add Todo',
            ),
          ],
        );
      },
    );
  }

  updateTodo(int index, Todo oldTodo) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    titleController.text = oldTodo.title;
    descriptionController.text = oldTodo.description;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          children: [
            TodoInput(
              titleController: titleController,
              descriptionController: descriptionController,
              onTap: () {
                Todo newTodo = Todo(
                  titleController.text,
                  descriptionController.text,
                );
                context.read<TodoBloc>().add(OnUpdateTodo(index, newTodo));
                Navigator.pop(context);
                DInfo.snackBarSuccess(context, 'Todo Successfully Edited!');
              },
              actionTitle: 'Update Todo',
            ),
          ],
        );
      },
    );
  }

  removeTodo(int index) {
    DInfo.dialogConfirmation(
            context, 'Remove TODO', 'Do you want to remove this todo?')
        .then((bool? yes) {
      if (yes ?? false) {
        context.read<TodoBloc>().add(OnRemoveTodo(index));
        DInfo.snackBarSuccess(context, 'Todo Removed!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TODO')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial) return const SizedBox.shrink();
          if (state is TodoLoading)
            return const Center(child: CircularProgressIndicator());
          List<Todo> list = state.todos;
          return ListView.builder(
            itemCount: list.length, // Use the actual length of the list
            itemBuilder: (context, index) {
              Todo todo = list[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 'update':
                        updateTodo(index, todo);
                        break;
                      case 'remove':
                        removeTodo(index);
                        break;
                      default:
                        DInfo.snackBarError(context, 'Invalid Menu');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'update', child: Text('Update')),
                    const PopupMenuItem(value: 'remove', child: Text('Remove')),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
