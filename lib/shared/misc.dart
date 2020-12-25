import 'dart:io';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getFileFromDialog() async {
  FileInfo fi;
  File f;
  String data = await FilePickerWritable().openFile((fileInfo, file) async {
    fi = fileInfo;
    f = file;
    return await f.readAsString();
  });
  if (fi == null)
    return null;
  else {
    return data;
  }
}

Future<void> saveFile({@required String data, @required String name}) async {
  var box = await Hive.openBox('box');
  await box.put(name, data);
}

Future<String> readFile(String name) async {
  var box = await Hive.openBox('box');
  return box.get(name);
}
