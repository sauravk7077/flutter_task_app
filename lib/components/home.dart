import 'package:flutter/material.dart';
import 'package:flutter_task_app/shared/misc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await syncData();
                var dataBox = Hive.box('data');
                print(dataBox.get('todos'));
              },
              icon: Icon(Icons.sync, color: Colors.white),
              label: Text(
                'Sync',
                style: TextStyle(color: Colors.white),
              )),
          FlatButton.icon(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/config');
            },
            label: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: Text("Todo App"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('data').listenable(),
        builder: (context, box, _) => Container(
          margin: EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: box.get('todos').length,
            itemBuilder: (buildContext, i) {
              return TodoCard(desc: box.get('todos')[i], title: "Task");
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
            ElevatedButton.icon(
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
