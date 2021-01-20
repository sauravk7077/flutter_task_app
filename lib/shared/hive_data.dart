import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Box dataBox, boxBox;

void initializeDatabase() async {
  Directory d = await getApplicationDocumentsDirectory();
  Hive..init(d.path);
  dataBox = await Hive.openBox('data');
  boxBox = await Hive.openBox('box');
}

ValueListenable<Box<dynamic>> getDataBoxListenable() {
  return dataBox.listenable();
}

Future<void> saveFileToBoxBox(
        {@required dynamic data, @required String name}) async =>
    await boxBox.put(name, data);

Future<String> readFileFromBoxBox(String name) async => await boxBox.get(name);

Future<void> saveFileToDataBox(
        {@required dynamic data, @required String name}) async =>
    await dataBox.put(name, data);

Future<dynamic> readFileFromDataBox(String name) async =>
    await dataBox.get(name);

void disposeBoxes() {
  dataBox.close();
  boxBox.close();
}
