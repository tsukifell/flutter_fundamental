import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';

class TodoInput extends StatelessWidget {
  const TodoInput(
      {super.key,
      required this.titleController,
      required this.descriptionController,
      required this.onTap,
      required this.actionTitle});

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onTap;
  final String actionTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DInput(title: "Title", controller: titleController, maxLine: 1),
        const SizedBox(height: 8),
        DInput(
            title: "Description",
            controller: descriptionController,
            maxLine: 1),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: onTap, child: Text(actionTitle))
      ],
    );
  }
}
