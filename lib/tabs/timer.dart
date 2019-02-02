import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';

class Timer extends StatelessWidget {
  @override
  Widget build (BuildContext context) => new Scaffold(
    backgroundColor: bluegrey_dark,

    //Content of tabs
    body: new PageView(
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Timer page content',
                style: TextStyle(color: white),)
          ],
        )
      ],
    ),
  );
}