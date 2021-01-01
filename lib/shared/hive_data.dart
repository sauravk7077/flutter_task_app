import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskc/taskc.dart';

Box dataBox, credBox;

Directory d;

Future<void> initializeDatabase(Directory _d) async {
  d = _d;
  Hive..init(d.path);
  dataBox = await Hive.openBox('data');
  credBox = await Hive.openBox('cred');
  File('${d.path}/.task/backlog.data').createSync(
    recursive: true,
  );
}

ValueListenable<Box<dynamic>> getDataBoxListenable() {
  return dataBox.listenable();
}

Future<void> addTask(Task task) async {
  File('${d.path}/.task/backlog.data').writeAsStringSync(
    '${json.encode(task.toJson())}\n',
    mode: FileMode.append,
  );
  await dataBox.put(task.uuid, task.toJson());
}

Future<void> saveFileToCredBox(
        {@required dynamic data, @required String name}) async =>
    await credBox.put(name, data);

dynamic readFileFromCredBox(String name) => credBox.get(name);

void disposeBoxes() {
  dataBox.close();
  credBox.close();
}
