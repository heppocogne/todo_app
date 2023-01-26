import 'package:hive/hive.dart';
import 'package:todo_app/repositories/repository.dart';

class IDProvider {
  final Repository _repo = Repository("IDs");

  final String categoriesKey = "categories_id";

  Future<int> getNewCategoryID() async{
    Box box = await _repo.getBox();
    if (box.containsKey(categoriesKey)) {
      int current = box.get(categoriesKey);
      box.put(categoriesKey, current + 1);
      return current + 1;
    } else {
      box.put(categoriesKey, 0);
      return 0;
    }
  }
}
