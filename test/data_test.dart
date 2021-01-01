import 'package:test/test.dart';
import 'package:flutter_task_app/shared/hive_data.dart';

void main() {
  test('The database is initialized', () async {
    await initializeDatabase();
    expect(dataBox, isNotNull);
    expect(credBox, isNotNull);
  });
}
