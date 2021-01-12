import 'package:flutter/material.dart';
import 'package:flutter_task_app/shared/misc.dart';

class Configuration extends StatefulWidget {
  static final _margin1 = EdgeInsets.all(20);
  static final _margin2 = EdgeInsets.all(10);

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final GlobalKey _formkey = GlobalKey();
  var _controllers = <TextEditingController>[
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: '')
  ];

  static List<String> _titles = <String>[
    "Input the CA File",
    "Input the Client Key File",
    "Input the Client Certificat File"
  ];

  void _importAndSetData(int idx) async {
    try {
      dynamic data = await getFileFromDialog();
      if (data != null) {
        _controllers[idx].text = data;
      }
    } catch (e) {
      print(e);
    }
  }

  void _saveToBox() async {
    try {
      for (int i = 0; i < _controllers.length; i++) {
        await saveFile(name: i.toString(), data: _controllers[i].text);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: SafeArea(
            child: Column(children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Setting",
                  style: Theme.of(context).textTheme.headline3)),
          Divider(
            height: 40,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                ListView.builder(
                  itemCount: _titles.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: Configuration._margin2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${_titles[index]}:"),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: Configuration._margin2,
                                    child: TextFormField(
                                      controller: _controllers[index],
                                    )),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _importAndSetData(index);
                                },
                                child: Text("Import"),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                //Ca File
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          child: Text("Save"), onPressed: _saveToBox),
                      RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ])
              ],
            ),
          ),
        ])));
  }
}
