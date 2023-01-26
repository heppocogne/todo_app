import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/repositories/repository.dart';

import '../models/category.dart';

class CategoryService {
  final Repository _categoriesRepo = Repository("categories");

  Future<int> saveCategory(int categoryID, Category category) async {
    Box box = await _categoriesRepo.getBox();
    box.put(categoryID, category.categoryMap());
    return categoryID;
  }

  readAllCategories() async {
    Box box = await _categoriesRepo.getBox();
    var categories = [];
    for (var key in box.keys) {
      categories.add(box.get(key));
    }
    return categories;
  }

  readCategory(int categoryID)async{
    Box box = await _categoriesRepo.getBox();
    return box.get(categoryID);
  }

  deleteCategory(int categoryID)async {
    Box box = await _categoriesRepo.getBox();
    return box.delete(categoryID);
  }
}
