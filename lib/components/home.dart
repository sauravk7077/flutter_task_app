import 'package:flutter/material.dart';
import 'package:flutter_task_app/shared/misc.dart';
import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:intl/intl.dart';
import 'package:taskc/taskc.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await syncData();
              },
              icon: Icon(Icons.sync),
              label: Text(
                'Sync',
              )),
          FlatButton.icon(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
            label: Text(
              'Settings',
            ),
          )
        ],
        title: Text("Todo App"),
      ),
      body: ValueListenableBuilder(
        valueListenable: getDataBoxListenable(),
        builder: (context, box, _) => Container(
          margin: EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: box.get('todos').length,
            itemBuilder: (buildContext, i) {
              return TodoCard(task: Task.fromJson(box.get('todos')[i]));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return TaskForm();
              });
          await syncData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final Task task;

  static final titleStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static final _borderStyle =
      BorderSide(color: Colors.grey[200], width: 2, style: BorderStyle.solid);

  const TodoCard({@required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border(
                            top: _borderStyle,
                            right: _borderStyle,
                            bottom: _borderStyle,
                            left: _borderStyle),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(DateFormat('kk:ss').format(task.modified)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TextEditingController _taskNameController =
      new TextEditingController(text: '');

  void _addData(context) async {
    await syncData(task: _taskNameController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Description", style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextFormField(controller: _taskNameController),
            ),
            SizedBox(height: 20),
            RaisedButton.icon(
              onPressed: () => _addData(context),
              label: Text("Add"),
              icon: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
