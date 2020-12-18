import 'package:flutter/material.dart';
import 'package:flutter_task_app/components/config.dart';
import 'package:flutter_task_app/components/loading.dart';
import 'package:flutter_task_app/components/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
