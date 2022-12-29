import 'dart:async';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackru/ui/pages/dashboard/social_media.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:hackru/defaults.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/annoucements/announcement_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../help/help.dart';
import '../home.dart';
import '../login/login_page.dart';
import '../qr_scanner/Scanner.dart';

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
  bool _isLoading = true;

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
    var hasToken = credManager!.hasCredentials();
    if (mounted) {
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
          username = userProfile.firstName + " " + userProfile.lastName;
          tempStatus = userProfile.registrationStatus;
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
    _isLoading = false;
  }

  /// =================================================
  ///                SHOW TIMER BANNER
  /// =================================================

  Widget timerTitle() {
    if (hackRUStart.difference(DateTime.now()).inDays > 0) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Current Time',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    } else {
      if (hackRUStart.isAfter(DateTime.now())) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hacking Begins In',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      } else if (hackRUStart.isBefore(DateTime.now()) &&
          hackRUEnd.isAfter(DateTime.now())) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hacking Ends In',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      } else {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Time',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }
    }
  }

  Future _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible = false}) {
        return AlertDialog(
          backgroundColor: HackRUColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Icon(
            Icons.people,
            color: HackRUColors.off_white,
            size: 50.0,
          ),
          content: Text(body,
              style:
                  const TextStyle(fontSize: 50, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: HackRUColors.yellow,
              height: 40.0,
              color: HackRUColors.off_white,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  color: HackRUColors.pink,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onGetAttending() async {
    var _storedEmail = credManager!.getEmail();
    var _authToken = credManager!.getAuthToken();
    var count = 0;
    try {
      count = await getAttending(_authToken);
      _scanDialogWarning("Total = " + count.toString());
    } on LcsError {
      var result = "Error Fetching Result.";
      _scanDialogWarning(result);
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
          SizedBox(width: 5),
          timerTitle(),
          Expanded(child: Container()),
          const TimerText(),
          SizedBox(width: 5)
        ],
      ),
    );
  }

  ///===========================================================
  ///                      SHOW QR-CODE
  ///===========================================================
  void _showQrCode() async {
    var userEmail = credManager!.getEmail();
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
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
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Center(
                child: QrImage(
                  version: 4,
                  data: userEmail,
                  gapless: true,
                  embeddedImage: const AssetImage(
                      'assets/hackru-logos/appIconImageWhite.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(50, 50),
                  ),
                  foregroundColor: HackRUColors.charcoal,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
        );
      },
    )) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //   child: timerTitle(),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _timerBanner(),
          ),
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
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Shimmer(
                                    gradient: LinearGradient(colors: [
                                      Colors.white,
                                      Colors.blueGrey.withOpacity(0.2)
                                    ]),
                                    child: Container(
                                        color: Colors.blueGrey.withOpacity(0.2),
                                        height: 33.33,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6)),
                                SizedBox(
                                  height: 5,
                                ),
                                Shimmer(
                                    gradient: LinearGradient(colors: [
                                      Colors.white,
                                      Colors.blueGrey.withOpacity(0.2)
                                    ]),
                                    child: Container(
                                        color: Colors.blueGrey.withOpacity(0.2),
                                        height: 28.33,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5))
                              ],
                            ),
                            Shimmer(
                                child: Container(
                                    height: 35,
                                    width: 35,
                                    color: Colors.blueGrey.withOpacity(0.2)),
                                gradient: LinearGradient(
                                    colors: [Colors.white, Colors.blueGrey]))
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                      fontFamily: 'newFont', fontSize: 25),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        userStatus,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          IconData(checkedin ? 0xe157 : 0xf68b,
                                              fontFamily: 'MaterialIcons'),
                                          color: checkedin
                                              ? Colors.green
                                              : Colors.red,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  _showQrCode();
                                },
                                icon: Icon(
                                  Icons.qr_code,
                                  size: 24,
                                ))
                          ],
                        ),
                ),
              ),
            ),
          ] else
            SizedBox(height: 5),
          Row(children: [
            if (!_hasAuthToken)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HackRUColors.yellow,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                    onPressed: () async {
                      var loginResponse;
                      var hasCred = credManager!.hasCredentials();
                      if (hasCred) {
                      } else {
                        loginResponse = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Provider.value(
                                value: credManager!, child: LoginPage()),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                      if (loginResponse != null &&
                          loginResponse != '' &&
                          mounted) {
                        ScaffoldMessengerState().clearSnackBars();
                        ScaffoldMessengerState().showSnackBar(
                          SnackBar(
                            content: Text(await loginResponse ?? ''),
                            backgroundColor: HackRUColors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: HackRUColors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HackRUColors.pink,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Help())),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Help",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: HackRUColors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
          if (credManager!.getAuthorization()) ...[
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: HackRUColors.pink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Provider.value(
                            value: credManager, child: Scanner()))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "QR Scanner",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          if (_hasAuthToken) ...[
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: HackRUColors.pink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                onPressed: () async {
                  credManager!.deleteCredentials();
                  setState(() {
                    _hasAuthToken = false;
                  });
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Provider.value(value: credManager!, child: Home()),
                      maintainState: false,
                    ),
                    ModalRoute.withName('/main'),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          if (credManager!.getAuthorization()) ...[
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: HackRUColors.pink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                onPressed: () => _onGetAttending(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Attending",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: HackRUColors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          Expanded(child: Container()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SocialMediaCard(
                onPressed: () => url_launcher.launch(HACK_RU_WEBSITE_URL),
                iconData: FontAwesomeIcons.link,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(REPOSITORY_URL),
                iconData: FontAwesomeIcons.github,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(FACEBOOK_PAGE_URL),
                iconData: FontAwesomeIcons.facebookSquare,
              ),
              SocialMediaCard(
                onPressed: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
                iconData: FontAwesomeIcons.instagram,
              ),
            ],
          ),
        ],
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
