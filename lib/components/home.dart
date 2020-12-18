import 'package:flutter/material.dart';
import 'package:taskc/taskc.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var t = Task(description: "Add a tomato");
    print(t);
    return Scaffold(
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
      body: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            TodoCard(title: "Potato", desc: "Add a potato"),
            TodoCard(title: "Potato", desc: "Add a potato"),
            TodoCard(title: "Potato", desc: "Add a potato"),
            TodoCard(title: "Potato", desc: "Add a potato")
          ],
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final String title;
  final String desc;

  static final titleStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  const TodoCard({@required this.title, @required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: titleStyle,
              textDirection: TextDirection.ltr,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(desc, textDirection: TextDirection.ltr),
          )
        ],
      ),
    );
  }
}
