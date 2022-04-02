import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/dashboard/announcement_card.dart';
// import 'package:hackru/ui/widgets/dialog/notification_onclick.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../widgets/flip_panel.dart';

// import 'package:hackru/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  var _displayTimerBanner = true;
  static DateTime cacheTTL = DateTime.now();

  final hackRUStartDate = DateTime.utc(1989, DateTime.november, 9);
  final hackRUEndDate = DateTime.utc(1989, DateTime.november, 9);
  final currentDate = DateTime.now();

  var startTime = DateTime(2022, DateTime.april, 2, 13, 0, 0);
  final diffStartEvent =
      DateTime(2022, DateTime.april, 2, 11, 0, 0).difference(DateTime.now());
  final diffEndEvent =
      DateTime(2022, DateTime.april, 3, 11, 0, 0).difference(DateTime.now());

  // late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    // setupPushNotifications();
    // _requestIOSPermissions();
    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();
  }

  /// ===========================================================
  ///                     PUSH NOTIFICATIONS
  /// ===========================================================

  // void _requestIOSPermissions() {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  // void _configureDidReceiveLocalNotificationSubject() {
  //   didReceiveLocalNotificationSubject.stream
  //       .listen((ReceivedNotification receivedNotification) async {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: receivedNotification.title != null
  //             ? Text(receivedNotification.title)
  //             : null,
  //         content: receivedNotification.body != null
  //             ? Text(receivedNotification.body)
  //             : null,
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: Text('Ok'),
  //             onPressed: () async {
  //               print('Not implemented Yet');
  //             },
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }

  // void _configureSelectNotificationSubject() {
  //   selectNotificationSubject.stream.listen((String payload) async {
  //     print('Payload: $payload');
  //     Map<String, dynamic> message = json.decode(payload);
  //     String title = message['data']['title'];
  //     String body = message['data']['body'];
  //     onPushNotificationClick(title, body);
  //   });
  // }

  // void setupPushNotifications() async {
  //   if (Platform.isIOS) {
  //     await _firebaseMessaging.requestPermission(
  //         sound: true, badge: true, alert: true);
  //     // TODO: complete implementation as of new docs
  //   }

  //   _firebaseMessaging. configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');

  //       //TODO Configure notification channel
  //       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //           'silent channel id',
  //           'silent channel name',
  //           'silent channel description',
  //           playSound: false,
  //           styleInformation: DefaultStyleInformation(true, true));
  //       var iOSPlatformChannelSpecifics =
  //           IOSNotificationDetails(presentSound: false);
  //       var platformChannelSpecifics = NotificationDetails(
  //           androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //       await flutterLocalNotificationsPlugin.show(
  //           0,
  //           message['notification']['title'],
  //           message['notification']['body'],
  //           platformChannelSpecifics,
  //           payload: json.encode(message));
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //       String title = message['data']['title'];
  //       String body = message['data']['body'];
  //       onPushNotificationClick(title, body);
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //       String title = message['data']['title'];
  //       String body = message['data']['body'];
  //       onPushNotificationClick(title, body);
  //     },
  //   );

  //   await _firebaseMessaging.subscribeToTopic('announcements');
  // }

  // void onPushNotificationClick(String title, String body) async {
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return NotificationOnClickDialog(
  //           title: title,
  //           body: body,
  //         );
  //       });
  // }

  /// =================================================
  ///                SHOW TIMER BANNER
  /// =================================================

  Widget _timerBanner() {
    // debugPrint('====== day: ${DateTime.now().day}');
    return MaterialBanner(
      padding: const EdgeInsets.all(10.0),
      leadingPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      leading: const Icon(
        Icons.timer,
        color: HackRUColors.white,
        size: 50.0,
      ),
      content: const Padding(
        padding: EdgeInsets.only(left: 15.0),
        //child: FlipClock.reverseCountdown(
        //  duration: (DateTime.now().day != 2 &&
        //          DateTime.now().day != 3 &&
        //          DateTime.now().month == DateTime.april)
        //      ? Duration(milliseconds: diffStartEvent.inMilliseconds)
        //      : Duration(milliseconds: diffEndEvent.inMilliseconds),
        //  digitColor: HackRUColors.pink,
        //  backgroundColor: HackRUColors.white,
        //  digitSize: 25,
        //),
        child: TimerText(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _displayTimerBanner = false;
            });
          },
          child: const Text(
            'Dismiss',
            style: TextStyle(
              color: HackRUColors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      backgroundColor: HackRUColors.transparent,
    );
  }

  /// =================================================
  ///                GET SLACK MESSAGES
  /// =================================================
  static List<Announcement>? cachedMsgs;

  Future<List<Announcement>> _getSlacks() async {
    // var streamCtrl = StreamController<List<Announcement>>();
    // if (cachedMsgs != null) {
    //   streamCtrl.sink.add(cachedMsgs!);
    // }
    var slackMessages = List<Announcement>.empty();
    try {
      await slackResources().then((slackMsgs) {
        // debugPrint('======= slacks: $slackMsgs');
        slackMessages = slackMsgs;
      });
      // if (cacheTTL.isBefore(DateTime.now())) {
      //   slackResources().then((slackMsgs) {
      //     streamCtrl.sink.add(slackMsgs);
      //     persistSlackAnnouncements(slackMsgs);
      //     cacheTTL = DateTime.now().add(Duration(minutes: 5));
      //     streamCtrl.close();
      //   });
      // }
    } catch (e) {
      print('***********************\nSlack data stream ctrl error: ' +
          e.toString());
    }
    return slackMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<Announcement>?>(
        future: _getSlacks(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Announcement>?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
                // child: Container(
                //   color: HackRUColors.transparent,
                //   height: 400.0,
                //   width: 400.0,
                //   child: const RiveAnimation.asset(
                //     'assets/flare/loading_indicator.flr',
                //     alignment: Alignment.center,
                //     fit: BoxFit.contain,
                //     animations: ['idle'],
                //   ),
                // ),
              );
            default:
              print('ERROR-->DASHBOARD: ${snapshot.hasError}');
              var resources = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 25.0,
                  ),
                  itemCount: _displayTimerBanner
                      ? resources.length + 2
                      : resources.length,
                  itemBuilder: (context, index) {
                    if (index == 0 && _displayTimerBanner) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Hacking Ends In',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: HackRUColors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: _timerBanner(),
                            ),
                          ),
                        ],
                      );
                    }
                    if (_displayTimerBanner ? index == 1 : index == 0) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
                        title: Text(
                          'Announcements',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        trailing: !_displayTimerBanner
                            ? IconButton(
                                icon: Icon(
                                  Icons.timer,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _displayTimerBanner = true;
                                  });
                                },
                              )
                            : null,
                      );
                    }
                    return AnnouncementCard(
                      resource: _displayTimerBanner
                          ? resources[index - 2]
                          : resources[index - 1],
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

/// ===============================================
///                   TIMER TEXT
/// ===============================================

class TimerText extends StatefulWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Duration? _dateTime;
  Timer? _timer;
  // final diffStartEvent =
  //     DateTime(2022, DateTime.april, 2, 10, 0, 0).difference(DateTime.now());
  // final diffEndEvent =
  //     DateTime(2022, DateTime.april, 3, 10, 0, 0).difference(DateTime.now());

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    var startTime = DateTime(2022, DateTime.april, 2, 13, 0, 0);
    var diffStartEvent =
        DateTime(2022, DateTime.april, 2, 11, 0, 0).difference(DateTime.now());
    var diffEndEvent =
        DateTime(2022, DateTime.april, 3, 11, 0, 0).difference(DateTime.now());
    setState(() {
      _dateTime = diffEndEvent;
      
      _timer = Timer(
        const Duration(seconds: 1) -
            Duration(milliseconds: _dateTime!.inMilliseconds),
        _updateTime,
      );
    });
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    // final days = seconds ~/ Duration.secondsPerDay;
    // seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    // if (days != 0) {
    //   tokens.add('0${days}');
    // }
    // if (days == 0) {
    //   tokens.add('00');
    // }
    if (tokens.isNotEmpty || hours != 0) {
      if (hours < 10) {
        tokens.add('0${hours}');
      } else {
        tokens.add('${hours}');
      }
    }
    if (hours == 0) {
      tokens.add('00');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      if (minutes < 10) {
        tokens.add('0${minutes}');
      } else {
        tokens.add('${minutes}');
      }
    }
    if (minutes == 0) {
      tokens.add('00');
    }
    if (seconds < 10) {
      tokens.add('0${seconds}');
    } else {
      tokens.add('${seconds}');
    }
    if (seconds == 0) {
      tokens.add('00');
    }

    return tokens.join(':');
  }

  @override
  Widget build(BuildContext context) {
    var displayTime = formatDuration(_dateTime!).split(':');
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
