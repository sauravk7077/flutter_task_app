import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_task_app/shared/hive_data.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getApplicationDocumentsDirectory()
        .then(initializeDatabase)
        .then((_) => Navigator.pushReplacementNamed(context, '/home'));

    return Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: LoadingFlipping.square(
                backgroundColor: Colors.black,
                borderColor: Colors.black,
              ),
            ),
            Text(
              'Loading',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              textDirection: TextDirection.ltr,
            )
          ],
        ));
  }
}
