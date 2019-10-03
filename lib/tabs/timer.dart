import 'dart:async';
import 'dart:math';

import 'package:HackRU/colors.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  @override
  TimerState createState() {
    return new TimerState();
  }
}

class TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width - 10.0;
    final imageHeight = 230.0;
    final toleranceFactor = 0.033;
    final widthFactor = 0.125;
    final heightFactor = 0.5;

    final random = Random();

    final bool debugMode = false;
    DateTime now = DateTime.now();
    DateTime dDay = DateTime(2019, 10, 20, 13, 00, 0);
    dDay = (debugMode)
        ? DateTime(
            now.year, now.month, now.day, now.hour, now.minute, now.second)
        : dDay;
    Duration _duration = dDay.difference(now);

    return Scaffold(
      backgroundColor: pink,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [0, 1, 2, 3, 4, 5, 6, 7]
                    .map((count) => FlipPanel.stream(
                          itemStream: Stream.fromFuture(Future.delayed(
                              Duration(milliseconds: random.nextInt(20) * 100),
                              () => 1)),
                          itemBuilder: (_, value) => value <= 0
                              ? Container(
                                  color: yellow,
                                  width: widthFactor * imageWidth,
                                  height: heightFactor * imageHeight,
                                )
                              : ClipRect(
                                  child: Align(
                                      alignment: Alignment(
                                          -1.0 +
                                              count * 2 * 0.125 +
                                              count * toleranceFactor,
                                          -1.0),
                                      widthFactor: widthFactor,
                                      heightFactor: heightFactor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.asset(
                                          'assets/images/hackru_banner.png',
                                          width: imageWidth,
                                          height: imageHeight,
                                        ),
                                      ))),
                          initValue: 0,
                          spacing: 0.0,
                          direction: FlipDirection.up,
                        ))
                    .toList(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [0, 1, 2, 3, 4, 5, 6, 7]
                    .map((count) => FlipPanel.stream(
                          itemStream: Stream.fromFuture(Future.delayed(
                              Duration(milliseconds: random.nextInt(20) * 100),
                              () => 1)),
                          itemBuilder: (_, value) => value <= 0
                              ? Container(
                                  color: yellow,
                                  width: widthFactor * imageWidth,
                                  height: heightFactor * imageHeight,
                                )
                              : ClipRect(
                                  child: Align(
                                      alignment: Alignment(
                                          -1.0 +
                                              count * 2 * 0.125 +
                                              count * toleranceFactor,
                                          1.0),
                                      widthFactor: widthFactor,
                                      heightFactor: heightFactor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.asset(
                                          'assets/images/hackru_banner.png',
                                          width: imageWidth,
                                          height: imageHeight,
                                        ),
                                      ))),
                          initValue: 0,
                          spacing: 0.0,
                          direction: FlipDirection.down,
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 10.0,
              ),
              (_duration.inHours > 23 && _duration.inHours.isNegative == false)
                  ? Text(
                      'HackRU Fall 2019 In...',
                      style: TextStyle(
                        color: off_white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : (_duration.isNegative == false)
                      ? Text(
                          'HackRU Ends In...',
                          style: TextStyle(
                            color: yellow,
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(''),
              Center(
                heightFactor: 0.0,
                widthFactor: 0.0,
                child: (_duration.isNegative == false)
                    ? FlipClock.reverseCountdown(
                        duration: _duration,
                        digitColor: pink,
                        backgroundColor: off_white,
                        digitSize: 35.0,
                        width: 25.0,
                        height: 45.0,
                        spacing: (MediaQuery.of(context).size.width <= 350)
                            ? EdgeInsets.only(
                                bottom: 35.0,
                                right: 4.0,
                              )
                            : EdgeInsets.all(0.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        onDone: () => print('Times Up!'),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 80.0,
                          ),
                          Text(
                            'Times Up!!\n\n Don\'t forget to submit your projects\n on DevPost. Thanks for attending\n HackRU Fall 2019!!!\n\n -- HackRU Organizing Team',
                            style: TextStyle(
                              color: pink,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
