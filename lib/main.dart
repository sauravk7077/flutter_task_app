import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';

import 'package:flutter_task_app/components/config.dart';
import 'package:flutter_task_app/components/loading.dart';
import 'package:flutter_task_app/components/home.dart';
import 'package:flutter_task_app/shared/hive_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(
      getApplicationDocumentsDirectory().then((d) => initializeDatabase(d)));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title =
      'task${kDebugMode ? ' 🐞' : (kProfileMode ? ' 🚀' : '')}';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/config': (context) => Configuration()
      },
    );
  }
}
