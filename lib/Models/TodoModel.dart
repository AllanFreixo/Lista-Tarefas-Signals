import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool completed;

  Todo({required this.title, this.description, bool? completedC})
      : id = const Uuid().v4(),
        completed = completedC ?? false;

  Todo copyWith({String? title, String? description, bool? completed}) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      completedC: completed ?? this.completed,
    );
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? "",
        title = json["title"] ?? "",
        description = json["description"] ?? "",
        completed = bool.parse(json["completed"]) ?? false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed.toString(),
    };
  }
}
