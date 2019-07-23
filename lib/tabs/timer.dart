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
    final imageWidth = 350.0;
    final imageHeight = 230.0;
    final toleranceFactor = 0.033;
    final widthFactor = 0.125;
    final heightFactor = 0.5;

    final random = Random();

    final bool debugMode = false;
    DateTime now = DateTime.now();
    DateTime dDay = DateTime(2019, 10, 19, 10, 00, 0);
    dDay = (debugMode)? DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second): dDay;
    Duration _duration = dDay.difference(now);

    return Scaffold(
      backgroundColor: pink,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [0,1,2,3,4,5,6,7].map((count) => FlipPanel.stream(
                  itemStream: Stream.fromFuture(Future.delayed(
                      Duration(milliseconds: random.nextInt(20) * 100),() => 1)),
                  itemBuilder: (_, value) => value <= 0 ? Container(
                    color: yellow,
                    width: widthFactor * imageWidth,
                    height: heightFactor * imageHeight,
                  )
                      : ClipRect(
                      child: Align(
                          alignment: Alignment(-1.0+count * 2 * 0.125+count * toleranceFactor, -1.0),
                          widthFactor: widthFactor,
                          heightFactor: heightFactor,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset('assets/images/hackru_banner.png',
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ))),
                  initValue: 0,
                  spacing: 0.0,
                  direction: FlipDirection.up,)).toList(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [0,1,2,3,4,5,6,7].map((count) => FlipPanel.stream(
                  itemStream: Stream.fromFuture(Future.delayed(
                      Duration(milliseconds: random.nextInt(20) * 100),() => 1)),
                  itemBuilder: (_, value) => value <= 0 ? Container(
                    color: yellow,
                    width: widthFactor * imageWidth,
                    height: heightFactor * imageHeight,
                  )
                      : ClipRect(
                      child: Align(alignment: Alignment(-1.0+count * 2 * 0.125+count * toleranceFactor, 1.0),
                          widthFactor: widthFactor,
                          heightFactor: heightFactor,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset('assets/images/hackru_banner.png',
                              width: imageWidth,
                              height: imageHeight,
                            ),
                          ))),
                  initValue: 0,
                  spacing: 0.0,
                  direction: FlipDirection.down,)).toList(),
              ),
              SizedBox(height: 12.0,),
              Text('HackRU Fall 2019 In...', style: TextStyle(color: yellow, fontSize: 30.0,), textAlign: TextAlign.center,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    heightFactor: 0.0,
                    widthFactor: 0.0,
                    child: FlipClock.reverseCountdown(
                      duration: _duration,
                      digitColor: pink,
                      backgroundColor: white,
                      digitSize: 40.0,
                      width: 30.0,
                      height: 55.0,
                      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                      onDone: () => print('Hacking ends!! Don\'t forget to submit your projects to DevPost. '
                          'Thanks for coming to HackRU Spring \'19!!!'),
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