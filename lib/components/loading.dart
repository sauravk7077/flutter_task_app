import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
