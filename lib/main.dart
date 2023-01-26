import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/app.dart';

void main()async{
  await Hive.initFlutter("todo_app");
  runApp(const App());
}
