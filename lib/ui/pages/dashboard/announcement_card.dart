import 'package:HackRU/models/models.dart';
import 'package:HackRU/models/string_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../styles.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({required this.resource});
  final Announcement resource;

  /// =================================================
  ///               CHECK FOR WEB-LINK
  /// =================================================
//  bool _isWebLink(String input) {
//    final matcher =  RegExp(
//        r'(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
//    final specialChar =  RegExp('/');
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
//        var linkText = link.replaceAll( RegExp(r'[<>]'), '');
//        webView =  WebView(
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

  @override
  Widget build(BuildContext context) {
    final _errorLoadingDataText = 'Error: Unable to retrieve messages!';
    var secs = resource.ts?.split('.')[0];
    var timeStr =
        DateTime.fromMillisecondsSinceEpoch(int.parse(secs!) * 1000).toLocal();
    var formattedTime = DateFormat('hh:mm a').format(timeStr);

    return Container(
      key: Key(resource.ts!),
      child: Card(
        elevation: 0.0,
        color: resource.text == _errorLoadingDataText
            ? HackRUColors.pink
            : Theme.of(context).dividerColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              resource.text == _errorLoadingDataText
                  ? Center(
                      child: Text(
                        _errorLoadingDataText,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: StringParser(
                        text: resource.text ?? '',
                      ),
                    ),

              /// TODO: Decide whether to show WebView or only meta image of a website
//             Card(
//              elevation: 0.0,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(15.0),
//              ),
//              child:  Container(
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
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind? kind})
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
      final dy = _dragDistance.dy.abs();
      final dx = _dragDistance.dx.abs();

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
