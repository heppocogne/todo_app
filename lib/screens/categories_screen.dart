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
  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescriptionController = TextEditingController();
  final IDProvider idProvider = IDProvider();
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = <Category>[];

  @override
  void initState() {
    super.initState();
    Future(() async {
      await getAllCategories();
    });
  }

  getAllCategories() async {
    _categories = <Category>[];
    var readMaps = await _categoryService.readAllCategories();
    setState(() {
      for (var m in readMaps) {
        var c = Category(m["id"], m["name"], m["description"]);
        _categories.add(c);
      }
    });
  }

  _editCategory(BuildContext context, int categoryID) async {
    var map = await _categoryService.readCategory(categoryID);
    setState(() {
      _editCategoryNameController.text = map["name"];
      _editCategoryDescriptionController.text = map["description"];
    });
    _editFormDialog(context, categoryID);
  }

  _showFormDialog(BuildContext context) {
    _categoryNameController.text = "";
    _categoryDescriptionController.text = "";
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
                  int id = await idProvider.getNewCategoryID();
                  Category c = Category(id, _categoryNameController.text,
                      _categoryDescriptionController.text);
                  await _categoryService.saveCategory(id, c);
                  Navigator.pop(context);
                  getAllCategories();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Saved"),
                  ));
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
  }

  _editFormDialog(BuildContext context, int categoryID) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit a Category Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Write a category",
                      labelText: "Category",
                    ),
                    controller: _editCategoryNameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Write a description",
                      labelText: "Description",
                    ),
                    controller: _editCategoryDescriptionController,
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
                  Category c = Category(
                      categoryID,
                      _editCategoryNameController.text,
                      _editCategoryDescriptionController.text);
                  await _categoryService.saveCategory(categoryID, c);
                  Navigator.pop(context);
                  getAllCategories();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Updated"),
                  ));
                },
                child: const Text("Update"),
              ),
            ],
          );
        });
  }

  _deleteFormDialog(BuildContext context, int categoryID) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete this category?"),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  await _categoryService.deleteCategory(categoryID);
                  Navigator.pop(context);
                  getAllCategories();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Deleted"),
                  ));
                },
                child: const Text("Delete"),
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
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            child: ListTile(
              leading: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _editCategory(context, _categories[index].id);
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categories[index].name),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      _deleteFormDialog(context, _categories[index].id);
                    },
                  ),
                ],
              ),
              //subtitle: Text(_categories[index].description),
            ),
          );
        },
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
