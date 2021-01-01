// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/services.dart';
import 'package:taskc/taskc.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:flutter_task_app/shared/errors/taskd_exception.dart';

Future<String> getFileFromDialog() async {
  FileInfo fi;
  File f;
  var data = await FilePickerWritable().openFile((fileInfo, file) async {
    fi = fileInfo;
    f = file;
    return f.readAsString();
  });
  if (fi == null) {
    return null;
  } else {
    return data;
  }
}

Task generateNewTask(String desc) {
  var time = DateTime.now().toUtc();
  return Task(
      status: 'pending',
      uuid: Uuid().v1(),
      entry: time,
      description: desc,
      modified: time,
      priority: 'L');
}

Future<Map> syncData() async {
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
    ca = utf8.encode(readFileFromCredBox('ca'));
    certificate = utf8.encode(readFileFromCredBox('certificate'));
    key = utf8.encode(readFileFromCredBox('key'));
    address = readFileFromCredBox('server');
    port = int.parse(readFileFromCredBox('port'));
    credentials = Credentials.fromString(readFileFromCredBox('credentials'));
  }
  var connection = Connection(
      address: address,
      port: port,
      context: SecurityContext()
        ..setTrustedCertificatesBytes(ca)
        ..useCertificateChainBytes(certificate)
        ..usePrivateKeyBytes(key),
      onBadCertificate: (Platform.isIOS) ? (_) => true : null);
  var response = await synchronize(
      connection: connection, credentials: credentials, payload: payload);
  print(response.header);
  for (var task in response.payload.tasks) {
    print(json.decode(task)['description']);
  }
  switch (response.header['code']) {
    case '200':
      for (var task in response.payload.tasks) {
        await addTask(Task.fromJson(json.decode(task)));
      }
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
      throw TaskdException(response.header);
  }
  for (var task in response.payload.tasks) {
    await dataBox.put(json.decode(task)['uuid'], json.decode(task));
  }

  return response.header;
}

double urgency(Task task) {
  // https://github.com/GothenburgBitFactory/taskwarrior/blob/v2.5.3/src/Task.cpp#L1912-L2031

  var result = 0.0;

  if (task.tags?.contains('next') ?? false) {
    result += 15;
  }

  switch (task.priority) {
    case 'H':
      result += 6;
      break;
    case 'M':
      result += 3.9;
      break;
    case 'L':
      result += 1.8;
      break;
    default:
  }

  result += 5.0 * urgencyScheduled(task);
  result += -3.0 * urgencyWaiting(task);
  result += 1.0 * urgencyTags(task);
  result += 12.0 * urgencyDue(task);
  result += 2.0 * urgencyAge(task);

  return num.parse(result.toStringAsFixed(3));
}

double urgencyScheduled(Task task) =>
    (task.scheduled != null && task.scheduled.isBefore(DateTime.now())) ? 1 : 0;

double urgencyWaiting(Task task) => (task.status == 'waiting') ? 1 : 0;

double urgencyTags(Task task) {
  if (task.tags?.isNotEmpty ?? false) {
    if (task.tags.length == 1) {
      return 0.8;
    } else if (task.tags.length == 2) {
      return 0.9;
    } else if (task.tags.length > 2) {
      return 1;
    }
  }
  return 0;
}

double urgencyDue(Task task) {
  if (task.due != null) {
    var daysOverdue = DateTime.now().difference(task.due).inSeconds / 86400;

    if (daysOverdue >= 7.0) {
      return 1;
    } else if (daysOverdue >= -14.0) {
      return num.parse(
          ((daysOverdue + 14) * 0.8 / 21 + 0.2).toStringAsFixed(3));
    }

    return 0.2;
  }
  return 0;
}

double urgencyAge(Task task) {
  if (task.entry != null) {
    var entryAge =
        DateTime.now().difference(task.entry).inMilliseconds / 86400000;
    if (entryAge >= 365) {
      return 1;
    } else {
      return num.parse((entryAge / 365).toStringAsFixed(3));
    }
  }
  return 0;
}

String age(DateTime dt) {
  var difference = DateTime.now().difference(dt);
  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}
