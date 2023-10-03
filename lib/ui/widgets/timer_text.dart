import 'dart:async';

import "package:flutter/material.dart";

import '../../styles.dart';

final hackRUStart = DateTime(2023, DateTime.october, 7, 12, 00, 00);
final hackRUEnd = DateTime(2023, DateTime.october, 8, 12, 00, 00);

DateTime today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

Widget timerBanner(Color bgColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: bgColor,
    ),
    child: Row(
      children: [
        const SizedBox(width: 5),
        timerTitle(textColor),
        Expanded(child: Container()),
        TimerText(textColor: textColor),
        const SizedBox(width: 5)
      ],
    ),
  );
}

Widget timerTitle(Color textColor) {
  if (hackRUStart.difference(DateTime.now()).inDays > 0) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Current Time',
        style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  } else {
    if (hackRUStart.isAfter(DateTime.now())) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hacking Starts In',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        ),
      );
    } else if (hackRUStart.isBefore(DateTime.now()) &&
        hackRUEnd.isAfter(DateTime.now())) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hacking Ends In',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Time',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        ),
      );
    }
  }
}

class TimerText extends StatefulWidget {
  const TimerText({Key? key, required this.textColor}) : super(key: key);
  final Color textColor;

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  var displayTime = ['00', '00', '00'];
  Duration _dateTime = today.difference(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _updateTime() {
    if (hackRUStart.difference(DateTime.now()).inDays > 0) {
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      setState(() {
        _dateTime = today.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: DateTime.now().millisecond),
          _updateTime,
        );
      });
    } else if (hackRUStart.isAfter(DateTime.now())) {
      //24 hours to start timer
      setState(() {
        _dateTime = hackRUStart.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: DateTime.now().millisecond),
          _updateTime,
        );
      });
    } else if (hackRUStart.isBefore(DateTime.now()) &&
        hackRUEnd.isAfter(DateTime.now())) {
      // timer during the event
      setState(() {
        _dateTime = hackRUEnd.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: DateTime.now().millisecond),
          _updateTime,
        );
      });
    } else {
      // timer after the event
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      setState(() {
        _dateTime = today.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: DateTime.now().millisecond),
          _updateTime,
        );
      });
    }
  }

  String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];

    if (hours != 0) {
      if (-10 < hours && hours < 10) {
        tokens.add('0${hours.abs()}');
      } else {
        tokens.add('${hours.abs()}');
      }
    } else {
      tokens.add('00');
    }
    if (minutes != 0) {
      if (-10 < minutes && minutes < 10) {
        tokens.add('0${minutes.abs()}');
      } else {
        tokens.add('${minutes.abs()}');
      }
    } else {
      tokens.add('00');
    }
    if (seconds != 0) {
      if (-10 < seconds && seconds < 10) {
        tokens.add('0${seconds.abs()}');
      } else {
        tokens.add('${seconds.abs()}');
      }
    } else {
      tokens.add('00');
    }
    return tokens.join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 2, left: 3, right: 3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      displayTime[0],
                      style: TextStyle(
                        height: 1,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Hours',
                      style: TextStyle(
                        height: 1,
                        fontSize: 10.0,
                        color: widget.textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 2, left: 3, right: 3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      displayTime[1],
                      style: TextStyle(
                        height: 1,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Mins',
                      style: TextStyle(
                        height: 1,
                        fontSize: 10.0,
                        color: widget.textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 7, left: 3, right: 3, bottom: 2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    child: Text(
                      // '00',
                      displayTime[2],
                      style: TextStyle(
                        height: 1,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Secs',
                      style: TextStyle(
                        height: 1,
                        fontSize: 10.0,
                        color: widget.textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
