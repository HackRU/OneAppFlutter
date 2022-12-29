import 'dart:async';

import "package:flutter/material.dart";

import '../../styles.dart';

final hackRUStart = DateTime(2022, DateTime.october, 2, 11, 00, 00);
final hackRUEnd = DateTime(2022, DateTime.october, 3, 12, 00, 00);
final currentDate = DateTime.now();
DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);

Widget timerBanner() {
  return Container(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: HackRUColors.green,
    ),
    child: Row(
      children: [
        const SizedBox(width: 5),
        timerTitle(),
        Expanded(child: Container()),
        const TimerText(),
        const SizedBox(width: 5)
      ],
    ),
  );
}

Widget timerTitle() {
  if (hackRUStart.difference(DateTime.now()).inDays > 0) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Current Time',
        style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  } else {
    if (hackRUStart.isAfter(DateTime.now())) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hacking Begins In',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else if (hackRUStart.isBefore(DateTime.now()) &&
        hackRUEnd.isAfter(DateTime.now())) {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hacking Ends In',
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else {
      return const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Time',
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }
  }
}

class TimerText extends StatefulWidget {
  const TimerText({Key? key}) : super(key: key);

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
      //current time
      DateTime today =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      setState(() {
        _dateTime = today.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: currentDate.millisecond),
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
              Duration(milliseconds: currentDate.millisecond),
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
              Duration(milliseconds: currentDate.millisecond),
          _updateTime,
        );
      });
    } else {
      // timer after the event
      DateTime today =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      setState(() {
        _dateTime = today.difference(DateTime.now());
        displayTime = formatDuration(_dateTime).split(':');
        _timer = Timer(
          const Duration(seconds: 1) -
              Duration(milliseconds: currentDate.millisecond),
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
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              // width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: HackRUColors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      // '00',
                      displayTime[0],
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Hours',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: HackRUColors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              // width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: HackRUColors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      // '00',
                      displayTime[1],
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Mins',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: HackRUColors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              // width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: HackRUColors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      // '00',
                      displayTime[2],
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      'Secs',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: HackRUColors.white,
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
