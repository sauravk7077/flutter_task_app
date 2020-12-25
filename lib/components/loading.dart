import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:hive/hive.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      var box = await Hive.box('box');
      if (box == null)
        Navigator.pushReplacementNamed(context, '/config');
      else
        Navigator.pushReplacementNamed(context, '/home');
    });
    return Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: LoadingFlipping.square(
                backgroundColor: Colors.white,
                borderColor: Colors.white,
              ),
            ),
            Text(
              "Loading",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textDirection: TextDirection.ltr,
            )
          ],
        ));
  }
}
