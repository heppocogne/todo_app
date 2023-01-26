import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class Repository {
  Repository(this.boxName);
  String boxName;
  Box? _box;

  getBox() async {
    _box ??= await Hive.openBox(boxName);
    return _box;
  }
}
