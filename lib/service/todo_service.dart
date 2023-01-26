import 'package:hive/hive.dart';
import 'package:todo_app/repositories/repository.dart';

import '../models/todo.dart';


class TodoService{
  final Repository _repo=Repository("todos");

  saveTodo(int todoID,Todo todo)async{
    Box box = await _repo.getBox();
    box.put(todoID, todo.todotMap());
  }

  readAllTodos()async{
    Box box = await _repo.getBox();
    var todos = [];
    for (var key in box.keys) {
      todos.add(box.get(key));
    }
    return todos;
  }
}