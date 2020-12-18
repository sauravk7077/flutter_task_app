import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  static final _margin = EdgeInsets.all(10);
  final GlobalKey _formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
          margin: _margin,
          child: Text("Setting", style: Theme.of(context).textTheme.headline3)),
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
            //Ca File
            Container(
              margin: _margin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Input the CA File:"),
                  Row(
                    children: [
                      Expanded(
                        child:
                            Container(padding: _margin, child: TextFormField()),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Import"),
                      )
                    ],
                  )
                ],
              ),
            ),
            //Ca File
            Container(
              margin: _margin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Input the Client Key File:"),
                  Row(
                    children: [
                      Expanded(
                        child:
                            Container(padding: _margin, child: TextFormField()),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Import"),
                      )
                    ],
                  )
                ],
              ),
            ),
            //Ca File
            Container(
              margin: _margin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Input the Client Certificate File:"),
                  Row(
                    children: [
                      Expanded(
                        child:
                            Container(padding: _margin, child: TextFormField()),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Import"),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(child: Text("Save"), onPressed: () {}),
              RaisedButton(child: Text("Close"), onPressed: () {})
            ])
          ],
        ),
      ),
    ])));
  }
}
