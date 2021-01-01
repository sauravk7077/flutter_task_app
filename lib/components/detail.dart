import 'package:flutter/material.dart';

import 'package:taskc/taskc.dart';

class Detail extends StatelessWidget {
  const Detail(this.task);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in {
              'Description': task.description,
              'Due': task.due,
              'End': task.end,
              'Entry': task.entry,
              'Modified': task.modified,
              'Priority': task.priority,
            }.entries)
              DetailCard(
                desc: entry.key,
                value: entry.value != null ? entry.value.toString() : 'Nil',
              ),
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({this.desc, this.value});

  final String desc;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 0.1,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                desc,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(padding: EdgeInsets.all(20), child: Text(value))
            ],
          ),
        ),
      ),
    );
  }
}
