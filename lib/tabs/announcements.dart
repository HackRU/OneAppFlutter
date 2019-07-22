import 'package:HackRU/loading_indicator.dart';
import 'package:HackRU/screens/string_parser.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/filestore.dart';
import 'dart:async';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({@required this.resource});
  final Announcement resource;

  Widget build (BuildContext context){
    String secs = resource.ts.split(".")[0];
    String time = DateTime.fromMillisecondsSinceEpoch(int.parse(secs)*1000).toIso8601String().substring(11,16);
    return new Container(
      child: new Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(time, style: TextStyle(color: yellow, fontWeight: FontWeight.w700),),
                SizedBox(height: 2.0,),
                new RichTextView(text: resource.text ?? ''),
              ],
            ),
            color: charcoal_light,
            padding: const EdgeInsets.all(15.0),
          ),
        ),
        elevation: 5.0,
        color: charcoal,
      ),
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
          return slackResources(DEV_URL);
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
      backgroundColor: charcoal,
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
          }
      )
  );
}
