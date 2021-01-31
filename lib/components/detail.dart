import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:taskc/taskc.dart';

import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:flutter_task_app/shared/misc.dart';

class Detail extends StatefulWidget {
  const Detail(this.task);

  final Task task;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic> map;

  @override
  void initState() {
    super.initState();
    map = {
      'description': widget.task.description,
      'due': widget.task.due,
      'end': widget.task.end,
      'entry': widget.task.entry,
      'modified': widget.task.modified,
      'priority': widget.task.priority
    };
  }

  Function updateState(String name) {
    return (dynamic value) {
      setState(() {
        map[name] = value;
      });
    };
  }

  Future<void> saveTask() async {
    print(map);
    var t = Task(
        description: map['description'],
        entry: DateTime.now().toUtc(),
        status: widget.task.status,
        uuid: widget.task.uuid,
        due: map['due'],
        end: map['end'],
        modified: DateTime.now().toUtc(),
        priority: map['priority']);

    await addTask(t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: saveTask,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in map.entries)
              DetailCard(
                uuid: widget.task.uuid,
                updateFunc: updateState(entry.key),
                desc: entry.key,
                value: entry.value != null
                    ? ((entry.value is DateTime)
                        // ignore: avoid_as
                        ? '${(entry.value as DateTime).toLocal()}'
                        : '${entry.value}')
                    : 'Nil',
              ),
          ],
        ),
      ),
    );
  }
}

class DetailCard extends StatefulWidget {
  const DetailCard({this.uuid, this.desc, this.value, this.updateFunc});

  final String uuid;
  final String desc;
  final String value;
  final Function updateFunc;

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.value);
  }

  String toTitleCase(String string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }

  TextEditingController _descController;

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
                toTitleCase(widget.desc),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.desc == 'priority')
                DropdownButton(
                    value: (widget.value == 'Nil') ? '' : widget.value,
                    items: [
                      for (var priority in ['H', 'M', 'L', ''])
                        DropdownMenuItem(
                          child: Text(priority),
                          value: priority,
                        ),
                    ],
                    onChanged: (priority) async {
                      widget.updateFunc(priority);
                    })
              else if (widget.desc == 'description')
                TextField(
                  controller: _descController,
                  onChanged: (value) {
                    widget.updateFunc(value);
                  },
                )
              else
                Container(
                    padding: EdgeInsets.all(20), child: Text(widget.value))
            ],
          ),
        ),
      ),
    );
  }
}
