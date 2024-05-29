import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:tarefas/Models/TodoModel.dart';
import 'package:tarefas/Repositorys/TodoRepository.dart';

class TodoController {
  var todos = <Todo>[].toSignal();
  TodoRepository todoRepository = TodoRepository();
  int? indexTodoDeleted;
  Todo? todoDeleted;
  List<Todo> todosDeleted = [];

  late final Computed<String> todoStatusString = computed(() {
    final notCompletedTodos = todos.where((todo) => !todo.completed);

    if (todos.isEmpty) {
      return "Você não possui nenhuma tarefa!";
    } else if (notCompletedTodos.isEmpty) {
      return "Parabéns todas as tarefas foram concluidas!";
    }

    return "Você possui ${notCompletedTodos.length} tarefa${notCompletedTodos
        .length == 1 ? '' : 's'}";
  });

  void addTodos(Todo todo) {
    todos.add(todo);
    todoRepository.safeListTodo(todos.value);
  }

  void removeTodo(Todo todo) {
    indexTodoDeleted = todos.indexOf(todo);
    todoDeleted = todo;
    todos.removeWhere((element) => element.id == todo.id);
    todoRepository.safeListTodo(todos.value);
  }

  void recoverTodo() {
    todos.insert(indexTodoDeleted!, todoDeleted!);
    todoRepository.safeListTodo(todos.value);
  }

  void removeAllTodos(){
    todosDeleted = List.from(todos.value);
    todos.clear();
    todoRepository.safeListTodo(todos.value);
  }

  void recoverTodos(){
    todos.value = List.from(todosDeleted);
    todoRepository.safeListTodo(todos.value);
  }

  void onChangeCompletedTodo(Todo todoUpdate) {
    todos.value = todos.map((todo) {
      if (todo.id == todoUpdate.id) {
        return todo.copyWith(completed: !todoUpdate.completed);
      }
      return todo;
    }).toList();
    todoRepository.safeListTodo(todos.value);
  }
}
