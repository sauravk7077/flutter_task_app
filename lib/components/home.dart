import 'package:flutter/material.dart';
import 'package:flutter_task_app/shared/misc.dart';
import 'package:flutter_task_app/shared/hive_data.dart';

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
              return TodoCard(desc: box.get('todos')[i]);
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
  final String desc;

  static final titleStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  const TodoCard({@required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(desc,
                    style: TextStyle(fontSize: 18),
                    textDirection: TextDirection.ltr)
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
