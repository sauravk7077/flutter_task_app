import 'dart:convert';
import 'dart:io';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskc/taskc.dart';
import 'package:uuid/uuid.dart';

Future<String> getFileFromDialog() async {
  FileInfo fi;
  File f;
  var data = await FilePickerWritable().openFile((fileInfo, file) async {
    fi = fileInfo;
    f = file;
    return await f.readAsString();
  });
  if (fi == null) {
    return null;
  } else {
    return data;
  }
}

Task generateNewTask(String desc) {
  var time = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  return Task(
      status: 'pending',
      uuid: Uuid().v1(),
      entry: time,
      description: desc,
      modified: time,
      priority: '0');
}

Future<void> syncData() async {
  try {
    var box = Hive.box('box');
    var d = await getApplicationDocumentsDirectory();
    var payload = File('${d.path}/.task/backlog.data').readAsStringSync();
    var ca;
    var certificate;
    var key;
    var address;
    var port;
    var credentials;
    try {
      ca = (await rootBundle.load('fixture/.task/ca.cert.pem'))
          .buffer
          .asUint8List();
      certificate = (await rootBundle.load('fixture/.task/first_last.cert.pem'))
          .buffer
          .asUint8List();
      key = (await rootBundle.load('fixture/.task/first_last.key.pem'))
          .buffer
          .asUint8List();
      var taskrc = parseTaskrc(await rootBundle.loadString('fixture/.taskrc'));
      var server = taskrc['taskd.server'].split(':');
      address = (Platform.isAndroid && server.first == 'localhost')
          ? '10.0.2.2'
          : server.first;
      port = int.parse(server.last);
      credentials = Credentials.fromString(taskrc['taskd.credentials']);
    } catch (_) {
      ca = utf8.encode(await box.get('0'));
      certificate = utf8.encode(await box.get('2'));
      key = utf8.encode(await box.get('1'));
      address = readFileFromCredBox('0');
      port = int.parse(readFileFromCredBox('1'));
      credentials = Credentials.fromString(readFileFromCredBox('2'));
    }
    var connection = Connection(
        address: address,
        port: port,
        context: SecurityContext()
          ..setTrustedCertificatesBytes(ca)
          ..useCertificateChainBytes(certificate)
          ..usePrivateKeyBytes(key),
        onBadCertificate: (_) => true);
    var response = await synchronize(
        connection: connection, credentials: credentials, payload: payload);
    print(response.header);
    for (var task in response.payload.tasks) {
      print(json.decode(task)['description']);
    }
    switch (response.header['code']) {
      case '200':
        response.payload.tasks.forEach(
          (task) => addTask(Task.fromJson(json.decode(task))),
        );
        File('${d.path}/.task/backlog.data').writeAsStringSync(
          '${response.payload.userKey}\n',
        );
        break;
      case '201':
        File('${d.path}/.task/backlog.data').writeAsStringSync(
          '${response.payload.userKey}\n',
        );
        break;
      default:
        throw Exception(response.header);
    }
    response.payload.tasks.forEach((task) {
      addTask(Task.fromJson(json.decode(task)));
    });
  } on Exception catch (e) {
    print(e);
  }
}
