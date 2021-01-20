// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_task_app/components/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_app/components/loading.dart';
import 'package:flutter_task_app/shared/misc.dart';
// import 'package:test/test.dart';

void main() {
  testWidgets('Card widget has title and description',
      (WidgetTester tester) async {
    await tester.pumpWidget(TodoCard(task: generateNewTask("desc")));
    final desc = find.text('desc');
    expect(desc, findsOneWidget);
  });
}
