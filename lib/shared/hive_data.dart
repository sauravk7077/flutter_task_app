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
  Hive.init('${d.path}/.task');
  dataBox = await Hive.openBox('data');
  credBox = await Hive.openBox('cred');
  File('${d.path}/.task/backlog.data').createSync(
    recursive: true,
  );
}

Future<void> resetDatabase() async {
  await File('${d.path}/.task').delete(
    recursive: true,
  );
  await initializeDatabase(d);
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

Future<Task> getTask(String uuid) =>
    Future.value(Task.fromJson(dataBox.get(uuid)));

Future<void> saveFileToCredBox(
        {@required dynamic data, @required String name}) =>
    credBox.put(name, data);

dynamic readFileFromCredBox(String name) => credBox.get(name);

void disposeBoxes() {
  dataBox.close();
  credBox.close();
}
