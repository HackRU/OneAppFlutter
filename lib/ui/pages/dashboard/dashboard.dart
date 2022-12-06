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
import 'package:hackru/ui/pages/annoucements/announcement_card.dart';
// import 'package:hackru/ui/widgets/dialog/notification_onclick.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  String _storedEmail = "";
  String username = "";
  String userStatus = "";
  bool _hasAuthToken = false;
  var _displayTimerBanner = true;
  String registrationStatus = "checked in";
  bool checkedin = false;
  String tempStatus = "";
  CredManager? credManager;

  // late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
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
    var hasToken = await credManager!.hasCredentials();
    if (this.mounted) {
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
  }

  void _getUserName() async {
    _storedEmail = credManager!.getEmail();
    if (_storedEmail != "") {
      var _authToken = credManager!.getAuthToken();
      var userProfile = await getUser(_authToken, _storedEmail);
      if (mounted) {
        setState(() {
          username =
              "Welcome, " + userProfile.firstName + " " + userProfile.lastName;
          tempStatus = userProfile.registrationStatus;
          //if (userProfile.registrationStatus == "unregistered") {
          if (userProfile.registrationStatus == "checked-in") {
            checkedin = true;
            userStatus = "You're checked-in!";
          } else {
            checkedin = false;
            userStatus = "You're not checked in yet.";
          }
        });
      }
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
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Time',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );
    } else {
      if (hackRUStart.isAfter(DateTime.now())) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hacking Begins In',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      } else if (hackRUStart.isBefore(DateTime.now()) &&
          hackRUEnd.isAfter(DateTime.now())) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hacking Ends In',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Time',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        );
      }
    }
  }

  Widget _timerBanner() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: HackRUColors.green,
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.timer,
                color: HackRUColors.white,
                size: 50.0,
              ),
            ),
          ),
          const TimerText(),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
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
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blueGrey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          // style: Theme.of(context).textTheme.subtitle1,
                          style: TextStyle(fontFamily: 'newFont', fontSize: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                userStatus,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  IconData(checkedin ? 0xe157 : 0xf68b,
                                      fontFamily: 'MaterialIcons'),
                                  color: checkedin ? Colors.green : Colors.red,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: timerTitle(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: _timerBanner(),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'QR Code',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HackRUColors.white,
                    HackRUColors.white,
                  ],
                ),
              ),
              child: Center(
                child: QrImage(
                  padding: EdgeInsets.all(5),
                  version: 4,
                  data: _storedEmail,
                  gapless: true,
                  embeddedImage: const AssetImage(
                      'assets/hackru-logos/appIconImageWhite.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(75, 75),
                  ),
                  foregroundColor: HackRUColors.charcoal,
                ),
              ),
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
