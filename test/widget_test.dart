// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_task_app/components/config.dart';
import 'package:flutter_task_app/components/home.dart';
import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:flutter_task_app/shared/misc.dart';

void main() {
  testWidgets('Card widget has title and description',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: TodoCard(task: generateNewTask('desc'))));
    final desc = find.text('desc');
    expect(desc, findsOneWidget);
  });

  testWidgets('Test configuration page in small window',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.binding.setSurfaceSize(Size(320, 480));
      await initializeDatabase(Directory('../fixture/${Uuid().v1()}'));
      await tester.pumpWidget(MaterialApp(home: Configuration()));
    });

    expect(tester.takeException(), isInstanceOf<Error>());
  });
}
