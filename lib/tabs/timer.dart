import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:flip_panel/flip_panel.dart';
import 'dart:async';
import 'dart:math';

class Timer extends StatefulWidget {
  @override
  TimerState createState() {
    return new TimerState();
  }
}

class TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    final imageWidth = 400.0;
    final imageHeight = 250.0;
    final toleranceFactor = 0.033;
    final widthFactor = 0.125;
    final heightFactor = 0.5;

    final random = Random();

    final bool debugMode = false;
    DateTime now = DateTime.now();
    DateTime dDay = DateTime(2019, 03, 09, 10, 0, 0);
    dDay = (debugMode)? DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second): dDay;
    Duration _duration = dDay.difference(now);

    return Scaffold(
      backgroundColor: bluegrey_dark,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/hackru_green_logo.png',
                    width: MediaQuery.of(context).size.width*0.8,
                    fit: BoxFit.contain,
                  )
                ]
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    heightFactor: 0.0,
                    widthFactor: 0.0,
                    child: FlipClock.reverseCountdown(
                      duration: _duration,
                      digitColor: bluegrey_dark,
                      backgroundColor: mintgreen_light,
                      digitSize: 40.0,
                      width: 30.0,
                      height: 55.0,
                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                      onDone: () => print('Thanks for coming!!!'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
