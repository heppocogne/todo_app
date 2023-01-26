import 'package:flutter/material.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/service/category_service.dart';

import '../models/category.dart';
import '../models/todo.dart';
import '../service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = <Todo>[];
  List<Category> _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    Future(() async {
      await getAllCategories();
      await getAllTodos();
    });
  }

  getAllTodos() async {
    _todos = <Todo>[];
    var ts = TodoService();
    var readMaps = await ts.readAllTodos();
    setState(() {
      for (var m in readMaps) {
        var t = Todo(
            m["id"], m["title"], m["description"], m["category"], m["date"]);
        _todos.add(t);
      }
    });
  }

  getAllCategories() async {
    _categories = <Category>[];
    var cs=CategoryService();
    var readMaps = await cs.readAllCategories();
    setState(() {
      for (var m in readMaps) {
        var c = Category(m["id"], m["name"], m["description"]);
        _categories.add(c);
      }
    });
  }

  _showAddDialog(BuildContext context)
  {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_todos[index].title),
                ],
              ),
              subtitle: Text((0<=_todos[index].category)?_categories[_todos[index].category].name:""),
              trailing: Text(_todos[index].date),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
