import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tarefas/Repositorys/TodoRepository.dart';
import '../Controllers/TodoController.dart';
import '../Models/TodoModel.dart';
import '../Widgets/addTodoFormWidget.dart';

TodoController todoController = TodoController();
final TodoRepository todoRepository = TodoRepository();

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    todoRepository.getListTodo().then((value) {
      setState(() {
        todoController.todos.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Lista de Tarefas com Signals",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlueAccent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => const addTodoFormWidget()),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: Watch((context) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    todoController.todoStatusString.value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: todoController.todos.length,
                itemBuilder: (_, int index) {
                  final todo = todoController.todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) =>
                          todoController.onChangeCompletedTodo(todo),
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      todo.description ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Ink(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.red,
                      ),
                      child: IconButton(
                        onPressed: () => deleteTodo(todo),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.red,
                  ),
                  child: IconButton(
                    onPressed: () => showDialogDeletedTodos(),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void deleteTodo(Todo todo) {
    todoController.removeTodo(todo);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        "Tarefa excluida com sucesso!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: "Desfazer",
        textColor: const Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            todoController.recoverTodo();
          });
        },
      ),
    ));
  }

  void deleteTodos() {
    setState(() {
      todoController.removeAllTodos();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        "Tarefas excluidas com sucesso!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: "Desfazer",
        textColor: const Color(0xff00d7f3),
        onPressed: () {
          setState(() {
            setState(() {
              todoController.recoverTodos();
            });
          });
        },
      ),
    ));
  }

  void showDialogDeletedTodos() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Apagar todas as tarefas"),
              content: const Text("Deseja realmente deletar todas as tarefas?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () {
                      deleteTodos();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Apagar",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ));
  }
}
