class TaskdException implements Exception {
  TaskdException(this.header);

  Map<String, String> header;

  @override
  String toString() => '$header';
}
