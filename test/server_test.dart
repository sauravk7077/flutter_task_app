// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:flutter_task_app/shared/misc.dart';

void main() async {
  bool localServerUnavailable;
  Socket socket;

  try {
    socket = await Socket.connect('localhost', 53589);
    localServerUnavailable = false;
    await socket.close();
  } on SocketException catch (_) {
    localServerUnavailable = true;
  }

  testWidgets('Add a task', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await initializeDatabase(Directory('../fixture/${Uuid().v1()}'));
      await addTask(generateNewTask('foo bar'));
      await syncData();
    });
  }, skip: localServerUnavailable);
}
