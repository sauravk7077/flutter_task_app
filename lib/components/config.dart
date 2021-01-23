import 'package:flutter/material.dart';
import 'package:flutter_task_app/shared/hive_data.dart';
import 'package:flutter_task_app/shared/misc.dart';

class Configuration extends StatefulWidget {
  static final _margin1 = EdgeInsets.all(20);
  static final _margin2 = EdgeInsets.all(10);

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final borderSide =
      BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid);
  final GlobalKey _formkey = GlobalKey();
  final GlobalKey _credFormkey = GlobalKey();
  var _controllers, _credentialControllers;
  static final List<String> _titles = <String>[
    'Input the CA File',
    'Input the Client Key File',
    'Input the Client Certificat File',
  ];

  @override
  void initState() {
    super.initState();
    _controllers = <TextEditingController>[
      TextEditingController(text: readFileFromPemBox('0')),
      TextEditingController(text: readFileFromPemBox('1')),
      TextEditingController(text: readFileFromPemBox('2')),
    ];
    _credentialControllers = <TextEditingController>[
      TextEditingController(text: readFileFromCredBox('0')),
      TextEditingController(text: readFileFromCredBox('1')),
      TextEditingController(text: readFileFromCredBox('2')),
    ];
  }

  static final InputDecoration _inputDeco =
      InputDecoration(enabledBorder: OutlineInputBorder());

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
      for (var i = 0; i < _controllers.length; i++) {
        await saveFileToPemBox(name: i.toString(), data: _controllers[i].text);
        await saveFileToCredBox(
            name: i.toString(), data: _credentialControllers[i].text);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget firstTab() {
    return Column(children: [
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
                      Padding(
                        child: Text('${_titles[index]}:'),
                        padding: Configuration._margin2,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                padding: Configuration._margin2,
                                child: TextFormField(
                                  decoration: _inputDeco,
                                  controller: _controllers[index],
                                )),
                          ),
                          MaterialButton(
                            onPressed: () {
                              _importAndSetData(index);
                            },
                            child: Text('Import'),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            //Ca File
          ],
        ),
      ),
    ]);
  }

  Widget secondTab() {
    return Container(
      margin: Configuration._margin1,
      child: Form(
        key: _credFormkey,
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Server',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _credentialControllers[0],
                decoration: _inputDeco,
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Port',
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _credentialControllers[1],
                decoration: _inputDeco,
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credentials',
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _credentialControllers[2],
                decoration: _inputDeco,
              )
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var istopRoute = !Navigator.of(context).canPop();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('Settings'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.security),
                  text: 'Certificates',
                ),
                Tab(
                  icon: Icon(Icons.verified_user),
                  text: 'Credentials',
                )
              ],
            ),
          ),
          body: TabBarView(children: [firstTab(), secondTab()]),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              _saveToBox();
              if (istopRoute) Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ));
  }
}
