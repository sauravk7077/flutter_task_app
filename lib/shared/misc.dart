import 'dart:convert';
import 'dart:io';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:taskc/taskc.dart';

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

final String server = "inthe.am";
final int port = 53589;
final String cred = "inthe_am/sauravk865/14d86820-40db-4291-9725-ea91573285fc";

Future<List<Task>> syncData({String task}) async {
  try {
    var box = Hive.box('box');
    var payload;
    if (task != null) payload = Payload.fromString(task);
    var connection = Connection(
        address: server,
        port: port,
        context: SecurityContext()
          ..useCertificateChainBytes(utf8.encode(box.get('2')))
          ..usePrivateKeyBytes(utf8.encode(box.get('1'))),
        onBadCertificate: (_) => true);
    var credentials = Credentials.fromString(cred);
    var response = await synchronize(
        connection: connection, credentials: credentials, payload: payload);
    return response.payload.tasks;
  } on Exception catch (e) {
    print(e);
    return null;
  }
}
