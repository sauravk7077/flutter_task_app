import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Box dataBox, boxBox, credBox;

void initializeDatabase() async {
  Directory d = await getApplicationDocumentsDirectory();
  Hive..init(d.path);
  dataBox = await Hive.openBox('data');
  boxBox = await Hive.openBox('box');
  credBox = await Hive.openBox('cred');
}

ValueListenable<Box<dynamic>> getDataBoxListenable() {
  return dataBox.listenable();
}

Future<void> saveFileToBoxBox(
        {@required dynamic data, @required String name}) async =>
    await boxBox.put(name, data);

String readFileFromBoxBox(String name) => boxBox.get(name);

Future<void> saveFileToDataBox(
        {@required dynamic data, @required String name}) async =>
    await dataBox.put(name, data);

dynamic readFileFromDataBox(String name) => dataBox.get(name);

Future<void> saveFileToCredBox(
        {@required dynamic data, @required String name}) async =>
    await credBox.put(name, data);

dynamic readFileFromCredBox(String name) => credBox.get(name);

void disposeBoxes() {
  dataBox.close();
  boxBox.close();
  credBox.close();
}
