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
            DetailCard(
              desc: 'Description',
              value: task.description,
            ),
            DetailCard(
              desc: 'Due',
              value: task.due != null ? task.due.toString() : 'Nil',
            ),
            DetailCard(
              desc: 'End',
              value: task.end != null ? task.end.toString() : 'Nil',
            ),
            DetailCard(
              desc: 'Entry',
              value: task.entry != null ? task.entry.toString() : 'Nil',
            ),
            DetailCard(
              desc: 'Modified',
              value: task.modified != null ? task.modified.toString() : 'Nil',
            ),
            DetailCard(
              desc: 'Priority',
              value: task.priority != null ? task.priority.toString() : 'Nil',
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  DetailCard({this.desc, this.value});

  final String desc;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 0.4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(desc),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(value))
            ],
          ),
        ),
      ),
    );
  }
}
