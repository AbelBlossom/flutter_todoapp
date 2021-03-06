import 'dart:math';

import 'package:flutter/material.dart';

const List<Color> _kKolors = [
  Color(0xff053F5E),
  Color(0xff16213E),
  Color(0xff27496D),
  Color(0xff0F3460),
  Color(0xff28518A),
  Color(0xff17223B),
  Color(0xff071E3D),
  Color(0xff003545),
];

Color getRandomColor() {
  final _random = Random();
  return _kKolors[_random.nextInt(_kKolors.length)];
}

var _testNames = [
  "Morning Todo",
  "Afternoon TodoList",
  "What to do after the saturday class"
];

class TodoProvider extends ChangeNotifier {
  List<TodoGroup> groups = _testNames.map((e) => TodoGroup(e)).toList();

  createNewGroup(String name) {
    var _group = TodoGroup(name);
    groups.add(_group);
    notifyListeners();
  }
}

class TodoGroup {
  String name;
  late Color color;
  List<Todo> todos = [];
  late DateTime date;
  // TodoGroup(this.name)
  //      :color = getRandomColor(),
  //       date = DateTime.now();

  TodoGroup(this.name)
      : color = getRandomColor(),
        date = DateTime.now();

  addTodo(Todo todo) => todos.add(todo);
}

class Todo {
  bool isCompleted;
  String _text;
  late DateTime date;
  Todo(
    this._text, {
    this.isCompleted = false,
  }) : date = DateTime.now();

  toggleDone() {
    isCompleted = !isCompleted;
  }

  update(String value) {
    this._text = value;
  }

  String get text {
    return _text;
  }
}
