import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build (BuildContext context) => new Scaffold(

    //Content of tabs
    body: new PageView(
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Announcements page content')
          ],
        )
      ],
    ),
  );
}