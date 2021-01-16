import 'package:flutter/material.dart';
import 'package:flutter_task_app/components/config.dart';
import 'package:flutter_task_app/components/loading.dart';
import 'package:flutter_task_app/components/home.dart';
import 'package:flutter_task_app/shared/hive_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/config': (context) => Configuration()
      },
    );
  }
}
