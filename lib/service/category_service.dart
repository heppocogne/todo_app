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
}
