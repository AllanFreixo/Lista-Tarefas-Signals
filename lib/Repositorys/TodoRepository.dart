import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/Models/TodoModel.dart';

const todoKey = "todoKey";

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getListTodo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoKey) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Todo.fromJson(e)).toList();
  }

  void safeListTodo(List<Todo> todos) async{
    sharedPreferences = await SharedPreferences.getInstance();
    final jsonString = json.encode(todos);
    sharedPreferences.setString(todoKey, jsonString);
  }
}
