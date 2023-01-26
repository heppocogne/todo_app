import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';
import 'package:todo_app/service/category_service.dart';

import '../models/category.dart';
import '../models/todo.dart';
import '../repositories/id_provider.dart';
import '../service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _todoTaskController = TextEditingController();
  final _todoDateController = TextEditingController();
  final IDProvider idProvider = IDProvider();
  var _selectedCategory; // Do not initialize this variable!
  var _categoryItems = <DropdownMenuItem>[];
  DateTime _dateTime = DateTime.now();

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
            m["id"], m["task"], m["category"], m["date"]);
        _todos.add(t);
      }
    });
  }

  getAllCategories() async {
    _categories = <Category>[];
    _categoryItems = <DropdownMenuItem>[];
    var cs = CategoryService();
    var readMaps = await cs.readAllCategories();
    setState(() {
      for (var m in readMaps) {
        var c = Category(m["id"], m["name"], m["description"]);
        _categories.add(c);

        _categoryItems.add(DropdownMenuItem(
          value: m["id"],
          child: Text(m["name"]),
        ));
      }
    });
  }

  _selectedTodoDate(BuildContext context) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateTime = picked;
      });
    }
  }

  _showAddDialog(BuildContext context) async {
    _todoTaskController.text = "";
    _dateTime = DateTime.now();
    _todoDateController.text = DateFormat("yyyy/MM/dd").format(_dateTime);
    _selectedCategory = null;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create a new task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Write a task",
                    labelText: "Task",
                  ),
                  controller: _todoTaskController,
                ),
                TextField(
                  controller: _todoDateController,
                  decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Pick a Date",
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedTodoDate(context);
                      },
                      child: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: _selectedCategory,
                  items: _categoryItems,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  hint: const Text("Category"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                int id = await idProvider.getNewTodoID();
                var todo = Todo(
                  id,
                  _todoTaskController.text,
                  _selectedCategory ?? -1,
                  _todoDateController.text,
                );
                var ts = TodoService();
                ts.saveTodo(id, todo);
                Navigator.pop(context);
                await getAllTodos();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Created"),
                ));
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
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
                  Text(_todos[index].task),
                ],
              ),
              subtitle: Text((0 <= _todos[index].category)
                  ? _categories[_todos[index].category].name
                  : ""),
              trailing: Text(_todos[index].date),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        /*
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),*/
        onPressed: () async {
          await getAllCategories();
          await _showAddDialog(context);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
