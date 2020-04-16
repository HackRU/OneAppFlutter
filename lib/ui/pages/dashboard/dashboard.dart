import 'dart:async';

import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/models/string_parser.dart';
import 'package:HackRU/ui/pages/dashboard/announcement_card.dart';
import 'package:HackRU/ui/widgets/flip_panel.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  var _displayTimerBanner = true;
  static DateTime cacheTTL = DateTime.now();

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
          child: Text('Dismiss', style: TextStyle(color: white, fontSize: 14.0, fontWeight: FontWeight.w700,),),
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
      getStoredSlacks().then((storedSlacks) {
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
          setStoredSlacks(networkSlacks);
          cacheTTL = DateTime.now().add(Duration(minutes: 9));
          streamCtrl.close();
        }
      });
    } catch (e) {
      print("***********************\nSlack data stream ctrl error: " + e);
    }
    return streamCtrl.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: new StreamBuilder<List<Announcement>>(
        stream: _getSlacks(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Announcement>> snapshot) {
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
                    animation: "idle",
                  ),
                ),
              );
            default:
              print(snapshot.hasError);
              var resources = snapshot.data;
              return new Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0,),
                child: new ListView.builder(
                  padding: EdgeInsets.only(bottom: 25.0,),
                  itemCount: _displayTimerBanner ? resources.length+2 : resources.length,
                  itemBuilder: (context, index) {
                    if(index == 0 && _displayTimerBanner){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: _timerBanner(),
                        ),
                      );
                    }
                    if(_displayTimerBanner ? index == 1 : index == 0){
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        title: Text(
                          'Announcements',
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        trailing: !_displayTimerBanner ? IconButton(
                          icon: Icon(Icons.timer, color: Theme.of(context).primaryColor,),
                          onPressed: (){
                            setState(() {
                              _displayTimerBanner = true;
                            });
                          },
                        ) : null,
                      );
                    }
                    return new AnnouncementCard(resource: _displayTimerBanner ? resources[index-2] : resources[index-1]);
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
      style: TextStyle(fontSize: 45.0, color: white,),
    );
  }
}
