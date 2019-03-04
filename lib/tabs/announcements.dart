import 'package:HackRU/models.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'dart:async';
import 'dart:convert';
import 'package:HackRU/screens/string_parser.dart';
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/filestore.dart';


// Create a stateful widget
class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> {
  Stream<List<SlackResource>> _getSlacks() {
    var streamctl = StreamController<List<SlackResource>>();
    getStoredSlacks().then((storedSlacks) {
        streamctl.sink.add(storedSlacks);
        return slackResources();
    }).then((networkSlacks){
        streamctl.sink.add(networkSlacks);
        setSlacks(networkSlacks);
    });
    return streamctl.stream;
  }

  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: bluegrey_dark,
      body: new FutureBuilder<List<SlackResource>>(
          future: slackResources(),
          builder: (BuildContext context, AsyncSnapshot<List<SlackResource>> snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(mintgreen_light), strokeWidth: 3.0,),
                );
              default:
                print(snapshot.hasError);
                var resources = snapshot.data;
                return new Container(
                    child: new ListView.builder(
                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          String ts = snapshot.data[index].ts;
                          String secs = snapshot.data[index].ts.split(".")[0];
                          String time = DateTime.fromMillisecondsSinceEpoch(int.parse(secs)*1000).toIso8601String().substring(11,16);
                          return new Container(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Card(
                                    child: new Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(time, style: TextStyle(color: bluegrey_dark, fontWeight: FontWeight.w900),),
                                          SizedBox(height: 2.0,),
                                          new RichTextView(text: snapshot.data[index].text ?? ''),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(15.0),
                                    ),
                                    elevation: 5.0,
                                  )
                                ],
                              )
                          );
                        }
                    ),
                );
            }
          }
      )
  );
}
