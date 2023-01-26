import 'package:hive/hive.dart';
import 'package:todo_app/repositories/repository.dart';

import '../models/category.dart';

class CategoryService {
  final Repository _repo = Repository("categories");

  saveCategory(int categoryID, Category category) async {
    Box box = await _repo.getBox();
    box.put(categoryID, category.categoryMap());
  }

  readAllCategories() async {
    Box box = await _repo.getBox();
    var categories = [];
    for (var key in box.keys) {
      categories.add(box.get(key));
    }
    return categories;
  }

  readCategory(int categoryID)async{
    Box box = await _repo.getBox();
    return box.get(categoryID);
  }

  deleteCategory(int categoryID)async {
    Box box = await _repo.getBox();
    return box.delete(categoryID);
  }
}
