// ignore_for_file: missing_required_param

import 'package:test/test.dart';
import 'package:taskc/taskc.dart';

import 'package:flutter_task_app/shared/misc.dart';

void main() {
  test('Test urgency function', () async {
    expect(urgency(Task()), 0);
    expect(urgency(Task(tags: ['+next'])), 15.8);
    expect(urgency(Task(priority: 'H')), 6);
  });
}
