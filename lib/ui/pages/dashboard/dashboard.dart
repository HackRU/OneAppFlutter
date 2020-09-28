import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/pages/dashboard/announcement_card.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:HackRU/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  var _displayTimerBanner = true;
  static DateTime cacheTTL = DateTime.now();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    setupPushNotifications();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  /// ===========================================================
  ///                     PUSH NOTIFICATIONS
  /// ===========================================================

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                print('Not implemented Yet');
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print('Payload: $payload');
      Map<String, dynamic> message = json.decode(payload);
      String title = message['data']['title'];
      String body = message['data']['body'];
      onPushNotificationClick(title, body);
    });
  }

  void setupPushNotifications() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      _firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings settings) {
        print('Settings registered: $settings');
      });
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');

        //TODO Configure notification channel
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'silent channel id',
            'silent channel name',
            'silent channel description',
            playSound: false,
            styleInformation: DefaultStyleInformation(true, true));
        var iOSPlatformChannelSpecifics =
            IOSNotificationDetails(presentSound: false);
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            message['notification']['title'],
            message['notification']['body'],
            platformChannelSpecifics,
            payload: json.encode(message));
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        String title = message['data']['title'];
        String body = message['data']['body'];
        onPushNotificationClick(title, body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        String title = message['data']['title'];
        String body = message['data']['body'];
        onPushNotificationClick(title, body);
      },
    );

    await _firebaseMessaging.subscribeToTopic('announcements');
  }

  void onPushNotificationClick(String title, String body) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 86,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  margin: EdgeInsets.only(top: 66),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    /*boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],*/
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Message: $body',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'OK',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Image.asset('assets/hackru-logos/hackru_white.png',
                          height: 100, width: 100),
                      radius: 66),
                )
              ],
            ),
          );
        });
  }

  /// =================================================
  ///                SHOW TIMER BANNER
  /// =================================================

  Widget _timerBanner() {
    return MaterialBanner(
      padding: EdgeInsets.all(10.0),
      leadingPadding: EdgeInsets.symmetric(horizontal: 10.0),
      leading: Icon(
        Icons.timer,
        color: white,
        size: 50.0,
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: TimerText(),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            setState(() {
              _displayTimerBanner = false;
            });
          },
          child: Text(
            'Dismiss',
            style: TextStyle(
              color: white,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      backgroundColor: transparent,
    );
  }

  /// =================================================
  ///                GET SLACK MESSAGES
  /// =================================================
  Stream<List<Announcement>> _getSlacks() {
    var streamCtrl = StreamController<List<Announcement>>();
    try {
      getSlackAnnouncements().then((storedSlacks) {
        if (storedSlacks != null) {
          streamCtrl.sink.add(storedSlacks);
        }
        if (cacheTTL.isBefore(DateTime.now())) {
          return slackResources();
        } else {
          return null;
        }
      }).then((networkSlacks) {
        if (networkSlacks != null) {
          streamCtrl.sink.add(networkSlacks);
          persistSlackAnnouncements(networkSlacks);
          cacheTTL = DateTime.now().add(Duration(minutes: 5));
          streamCtrl.close();
        }
      });
    } catch (e) {
      print('***********************\nSlack data stream ctrl error: ' + e);
    }
    return streamCtrl.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<Announcement>>(
        stream: _getSlacks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Announcement>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  color: transparent,
                  height: 400.0,
                  width: 400.0,
                  child: FlareActor(
                    'assets/flare/loading_indicator.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: 'idle',
                  ),
                ),
              );
            default:
              print('ERROR-->DASHBOARD: ${snapshot.hasError}');
              var resources = snapshot.data;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: 25.0,
                  ),
                  itemCount: _displayTimerBanner
                      ? resources.length + 2
                      : resources.length,
                  itemBuilder: (context, index) {
                    if (index == 0 && _displayTimerBanner) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: _timerBanner(),
                        ),
                      );
                    }
                    if (_displayTimerBanner ? index == 1 : index == 0) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
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
                            : resources[index - 1]);
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
  const TimerText({Key key}) : super(key: key);

  @override
  _TimerTextState createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

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
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('HH:mm:ss').format(_dateTime),
      style: TextStyle(
        fontSize: 45.0,
        color: white,
      ),
    );
  }
}
