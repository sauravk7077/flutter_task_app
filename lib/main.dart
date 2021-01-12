import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/components/config.dart';
import 'package:flutter_task_app/components/loading.dart';
import 'package:flutter_task_app/components/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory d = await getApplicationDocumentsDirectory();
  Hive..init(d.path);
  await Hive.openBox('box');
  await Hive.openBox('data');
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
