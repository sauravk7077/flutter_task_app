import 'dart:io';

import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_task_app/shared/hive_data.dart';

void main() {
  test('The database is initialized', () async {
    await initializeDatabase(Directory('../fixture/${Uuid().v1()}'));
    expect(dataBox, isNotNull);
    expect(credBox, isNotNull);
  });
}
