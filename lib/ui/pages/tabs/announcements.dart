import 'dart:async';

import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/models/string_parser.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({@required this.resource});
  final Announcement resource;

  bool _isWebLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    final specialChar = new RegExp("/");
    return matcher.hasMatch(input) && specialChar.hasMatch(input);
  }

  _enableWebview(String text) {
    final words = text.split(' ');
    WebView webView;
    words.forEach((link) {
      if (_isWebLink(link)) {
        var linkText = link.replaceAll(new RegExp(r'[<>]'), '');
        webView = new WebView(
          initialUrl: linkText ?? '[null]',
          gestureRecognizers: [
            Factory(() => PlatformViewVerticalGestureRecognizer()),
          ].toSet(),
          javascriptMode: JavascriptMode.unrestricted,
        );
      }
    });
    return webView;
  }

  Widget build(BuildContext context) {
    String secs = resource.ts.split(".")[0];
    var timeStr =
        DateTime.fromMillisecondsSinceEpoch(int.parse(secs) * 1000).toLocal();
    var formattedTime = new DateFormat('hh:mm a').format(timeStr);

    return new Container(
      key: Key(resource.ts),
      child: new Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  formattedTime,
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0),
                ),
                SizedBox(
                  height: 2.0,
                ),
                new StringParser(
                  text: resource.text ?? '',
                ),
                SizedBox(
                  height: 6.0,
                ),
                new ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: new Container(
                    child: _enableWebview(resource.text),
                    height: _isWebLink(resource.text) ? 250.0 : 0.0,
                  ),
                ),
              ],
            ),
            color: pink_light,
            padding: const EdgeInsets.all(15.0),
          ),
        ),
        borderOnForeground: true,
        elevation: 0.0,
        color: pink,
      ),
    );
  }
}

class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> {
  static DateTime cacheTTL = DateTime.now();

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
  Widget build(BuildContext context) => new Scaffold(
        backgroundColor: pink,
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
                    itemCount: resources.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new AnnouncementCard(resource: resources[index]);
                    },
                  ),
                );
            }
          },
        ),
      );
}

// Source credit for following class: https://cutt.ly/mwdVxtM
class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
