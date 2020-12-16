import 'package:flutter/material.dart';
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
      routes: {'/': (context) => Loading(), '/home': (context) => Home()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Loading() ??
        Scaffold(
            appBar: AppBar(
              actions: [
                FlatButton.icon(
                    shape: CircleBorder(),
                    onPressed: () {},
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    )),
                FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.sync, color: Colors.white),
                    label: Text(
                      'Sync',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
              title: Text("Todo App"),
            ),
            body:
                Home() // This trailing comma makes auto-formatting nicer for build methods.
            );
  }
}
