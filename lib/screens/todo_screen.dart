import 'package:flutter/material.dart';
import 'package:todo_app/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/service/todo_service.dart';

import '../models/todo.dart';
import '../repositories/id_provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _todoTitleController = TextEditingController();
  final _todoDescriptionController = TextEditingController();
  final _todoDateController = TextEditingController();
  final IDProvider idProvider = IDProvider();
  var _selectedCategory; // Do not initialize this variable!
  final _categories = <DropdownMenuItem>[];
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future(() async {
      await _loadCategories();
      _todoDateController.text = DateFormat("yyyy/MM/dd").format(_dateTime);
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

  _loadCategories() async {
    var cs = CategoryService();
    var categories = await cs.readAllCategories();
    setState(() {
      categories.forEach((category) {
        _categories.add(DropdownMenuItem(
          value: category["id"],
          child: Text(category["name"]),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _todoTitleController.text = "";
    _todoDescriptionController.text = "";
    _dateTime = DateTime.now();
    _todoDateController.text = DateFormat("yyyy/MM/dd").format(_dateTime);
    _selectedCategory = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Write Todo Title",
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Write Todo Description",
              ),
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
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              hint: const Text("Category"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                int id = await idProvider.getNewTodoID();
                var todo = Todo(
                  id,
                  _todoTitleController.text,
                  _todoDescriptionController.text,
                  _selectedCategory ?? -1,
                  _todoDateController.text,
                );
                var ts = TodoService();
                ts.saveTodo(id, todo);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Saved"),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
