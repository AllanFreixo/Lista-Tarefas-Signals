import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/Screens/TodoScreen.dart';

import '../Models/TodoModel.dart';

class addTodoFormWidget extends StatefulWidget {
  const addTodoFormWidget({super.key});

  @override
  State<addTodoFormWidget> createState() => _addTodoFormWidgetState();
}

class _addTodoFormWidgetState extends State<addTodoFormWidget> {
  final titleText = TextEditingController();
  final descriptionText = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void onAddTodo() {
    if (formKey.currentState!.validate()) {
      final todo =
          Todo(title: titleText.text, description: descriptionText.text);
      todoController.addTodos(todo);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: titleText,
                validator: (String? newTitle) {
                  if (newTitle.toString().isEmpty || newTitle == null) {
                    return "Por favor insira um Titulo";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Titulo",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionText,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Descrição",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Ink(
                decoration: const ShapeDecoration(
                    shape: CircleBorder(), color: Colors.teal),
                child: IconButton(
                  onPressed: onAddTodo,
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  iconSize: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
