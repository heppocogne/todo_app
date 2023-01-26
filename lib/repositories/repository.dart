import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class Repository {
  Repository(this.boxName);
  String boxName;
  Box? _box;

  getBox() async {
    if (_box != null) {
      return _box;
    } else {
      _box = await Hive.openBox(boxName);
      return _box;
    }
  }
}
