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

  /// =================================================
  ///               CHECK FOR WEB-LINK
  /// =================================================
//  bool _isWebLink(String input) {
//    final matcher = new RegExp(
//        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
//    final specialChar = new RegExp("/");
//    return matcher.hasMatch(input) && specialChar.hasMatch(input);
//  }

  /// =================================================
  ///                ENABLE WEB VIEW
  /// =================================================
//  _enableWebview(String text) {
//    final words = text.split(' ');
//    WebView webView;
//    words.forEach((link) {
//      if (_isWebLink(link)) {
//        var linkText = link.replaceAll(new RegExp(r'[<>]'), '');
//        webView = new WebView(
//          initialUrl: linkText ?? '[null]',
//          gestureRecognizers: [
//            Factory(() => PlatformViewVerticalGestureRecognizer()),
//          ].toSet(),
//          javascriptMode: JavascriptMode.unrestricted,
//        );
//      }
//    });
//    return webView;
//  }

  Widget build(BuildContext context) {
    String secs = resource.ts.split(".")[0];
    var timeStr =
        DateTime.fromMillisecondsSinceEpoch(int.parse(secs) * 1000).toLocal();
    var formattedTime = new DateFormat('hh:mm a').format(timeStr);

    return new Container(
      key: Key(resource.ts),
      child: new Card(
        elevation: 0.0,
        color: Theme.of(context).dividerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  formattedTime,
                  style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w700,),
                ),
                subtitle: StringParser(
                  text: resource.text ?? '',
                ),
              ),
              /// TODO: Decide whether to show WebView or only meta image of a website
//            new Card(
//              elevation: 0.0,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(15.0),
//              ),
//              child: new Container(
//                child: _enableWebview(resource.text),
//                height: _isWebLink(resource.text) ? 250.0 : 0.0,
//              ),
//            ),
            ],
          ),
        ),
      ),
    );
  }
}

// Source credit for following class: https://cutt.ly/mwdVxtM
/// =================================================
///           VERTICAL GESTURE RECOGNIZER
/// =================================================

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
