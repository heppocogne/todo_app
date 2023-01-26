import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';
import 'package:todo_app/service/category_service.dart';

import '../repositories/id_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();
  final IDProvider idProvider = IDProvider();
  final CategoryService _categoryService = CategoryService();

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Categories Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Write a category",
                      labelText: "Category",
                    ),
                    controller: _categoryNameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Write a description",
                      labelText: "Description",
                    ),
                    controller: _categoryDescriptionController,
                  )
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
                  Category c = Category(_categoryNameController.text,_categoryDescriptionController.text
                      );
                  int result = await _categoryService.saveCategory(
                      await idProvider.getNewCategoryID(), c);
                  debugPrint("$result:${c.categoryMap()}");
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: const Center(
        child: Text("Welcome to Categories Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
