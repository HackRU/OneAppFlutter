import 'package:HackRU/loading_indicator.dart';
import 'package:HackRU/screens/string_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/filestore.dart';
import 'dart:async';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({@required this.resource});
  final Announcement resource;

  BoxDecoration hackRUBoxDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: white,
          width: 0.5,
        ),
      ),
    );
  }

  bool _isWebLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    final specialChar = new RegExp("/");
    return matcher.hasMatch(input) && specialChar.hasMatch(input);
  }

  _enableWebview(String text){
    final words = text.split(' ');
    WebView webView;
    words.forEach((link) {
      if (_isWebLink(link)) {
        var linkText = link.replaceAll(new RegExp(r'[<>]'), '');
        webView = new WebView(
          initialUrl: linkText ?? '[null]',
          gestureRecognizers: Set()
            ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())),
          javascriptMode: JavascriptMode.unrestricted,
        );
      }
    });
    return webView;
  }

  Widget build (BuildContext context){
    String secs = resource.ts.split(".")[0];
    String time = DateTime.fromMillisecondsSinceEpoch(int.parse(secs)*1000).toIso8601String().substring(11,16);
//    return Container(
//      margin: const EdgeInsets.all(5.0),
//      padding: const EdgeInsets.all(15.0),
//      decoration: hackRUBoxDecoration(),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          new Text(time, style: TextStyle(color: off_white, fontWeight: FontWeight.w600, fontSize: 18.0),),
//          SizedBox(height: 3.0,),
//          new RichTextView(text: resource.text ?? ''),
//        ],
//      ),
//    );
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
                new Text(time, style: TextStyle(color: white, fontWeight: FontWeight.w800, fontSize: 16.0),),
                SizedBox(height: 2.0,),
                new StringParser(text: resource.text ?? ''),
                SizedBox(height: 6.0,),
                new ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: new Container(
                    child: _enableWebview(resource.text),
                    height: _isWebLink(resource.text) ? 250.0 : 0.0,
                  ),
                ),
              ],
            ),
            color: card_color,
            padding: const EdgeInsets.all(15.0),
          ),
        ),
        borderOnForeground: true,
        elevation: 0.0,
        color: pink,
      ),
//      decoration: hackRUBoxDecoration(),
    );
  }
}

// Create a stateful widget
class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}


class AnnouncementsState extends State<Announcements> {
  static DateTime cacheTTL = DateTime.now();

  Stream<List<Announcement>> _getSlacks() {
    var streamctl = StreamController<List<Announcement>>();
    getStoredSlacks().then((storedSlacks) {
        if (storedSlacks != null) {
          streamctl.sink.add(storedSlacks);
        }
        if (cacheTTL.isBefore(DateTime.now())) {
          return slackResources(PROD_URL);
        } else {
          return null;
        }
    }).then((networkSlacks){
        if (networkSlacks != null) {
          streamctl.sink.add(networkSlacks);
          setStoredSlacks(networkSlacks);
          cacheTTL = DateTime.now().add(Duration(minutes: 9));
        }
    });
    return streamctl.stream;
  }

  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: pink,
      body: new StreamBuilder<List<Announcement>>(
          stream: _getSlacks(),
          builder: (BuildContext context, AsyncSnapshot<List<Announcement>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: new ColorLoader2(),
                );
              default:
                print(snapshot.hasError);
                var resources = snapshot.data;
                return new Container(
                    child: new ListView.builder(
                        itemCount: resources.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new AnnouncementCard(resource: resources[index]);
                        }
                    )
                );
            }
          },
      )
  );
}
