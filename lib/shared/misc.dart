import 'dart:io';

import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getFileFromDialog() async {
  var list = await FilePickerWritable().openFile((fileInfo, file) async {
    return <dynamic>[fileInfo, file];
  });
  if (list[0] == null)
    return null;
  else
    return FilePickerWritable().readFile(
        identifier: list[0].identifier,
        reader: (fileInfo, file) async {
          return await file.readAsString();
        });
}

Future<void> saveFile(string, name) async {
  Directory d = await getApplicationDocumentsDirectory();
  Hive..init(d.path);
  var box = await Hive.box('dataBox');
  await box.put(name, string);
}

Future<String> readFile(name) async {
  Directory d = await getApplicationDocumentsDirectory();
  Hive..init(d.path);
  var box = await Hive.openBox('dataBox');
  return box.get(name);
}
