import 'dart:async';
// import 'dart:html';

// import 'package:flutter_countdown_timer/countdown.dart';
// import 'package:flutter_countdown_timer/index.dart';
// import 'package:hackru/main.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
// import 'package:hackru/ui/hackru_app.dart';
import 'package:hackru/ui/pages/dashboard/announcement_card.dart';
// import 'package:hackru/ui/widgets/dialog/notification_onclick.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:hackru/ui/pages/home.dart';
// import 'package:intl/intl.dart';

// import '../../widgets/flip_panel.dart';

// import 'package:hackru/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final hackRUStart = DateTime(2022, DateTime.october, 2, 11, 00, 00);
final hackRUEnd = DateTime(2022, DateTime.october, 3, 12, 00, 00);
final currentDate = DateTime.now();
DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  String username = "";
  String userStatus = "";
  bool _hasAuthToken = false;
  var _displayTimerBanner = true;

  // late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _hasToken();
    _getUserName();
    // setupPushNotifications();
    // _requestIOSPermissions();
    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void _hasToken() async {
    var hasToken = await hasCredentials();
    if (hasToken) {
      setState(() {
        _hasAuthToken = true;
      });
    } else {
      setState(() {
        _hasAuthToken = false;
      });
    }
  }

  void _getUserName() async {
    var _storedEmail = await getEmail();
    if (_storedEmail != "") {
      var _authToken = await getAuthToken();
      var userProfile = await getUser(_authToken!, _storedEmail!);
      setState(() {
        username =
            "Welcome, " + userProfile.firstName + " " + userProfile.lastName;
        userStatus = "Current status: " + userProfile.registrationStatus;
      });
    }
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

  Widget timerTitle() {
    if (hackRUStart.difference(DateTime.now()).inDays > 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Time',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
    } else {
      if (hackRUStart.isAfter(DateTime.now())) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hacking Begins In',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        );
      } else if (hackRUStart.isBefore(DateTime.now()) &&
          hackRUEnd.isAfter(DateTime.now())) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hacking Ends In',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Current Time',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        );
      }
    }
  }

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
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            if (_hasAuthToken) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    username,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    userStatus,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ],
            if (_displayTimerBanner) ...[
              timerTitle(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
            if (!_displayTimerBanner)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                title: Text(
                  'Timer',
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
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Announcements:',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            FutureBuilder<List<Announcement>?>(
              future: _getSlacks(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Announcement>?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: const [
                          Center(
                            child: Text("Fetching Announcements from Slack..."),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      debugPrint('ERROR-->DASHBOARD: ${snapshot.hasError}');
                    }

                    var resources = [];
                    resources = snapshot.data!;
                    debugPrint(resources.length.toString());
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 25.0,
                        ),
                        // itemCount: resources.length+1,
                        controller: ScrollController(),
                        itemCount: resources.length,
                        itemBuilder: (context, index) {
                          return AnnouncementCard(
                            resource: resources[index],
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ],
        ),
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
