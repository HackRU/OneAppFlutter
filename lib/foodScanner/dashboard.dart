import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: off_white,
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(color: off_white),),
        backgroundColor: pink,
        iconTheme: IconThemeData(color: off_white),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {},
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
