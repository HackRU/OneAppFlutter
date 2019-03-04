import 'package:HackRU/screens/string_parser.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({@required this.resource});
  final Announcement resource;

  Widget build (BuildContext context){
    String secs = resource.ts.split(".")[0];
    String time = DateTime.fromMillisecondsSinceEpoch(int.parse(secs)*1000).toIso8601String().substring(11,16);
    return Card(
      child: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(time, style: TextStyle(color: bluegrey_dark, fontWeight: FontWeight.w900),),
            SizedBox(height: 2.0,),
            new RichTextView(text: resource.text ?? ''),
          ],
        ),
        padding: const EdgeInsets.all(15.0),
      ),
      elevation: 5.0,
    );
  }
}

class Announcements extends StatelessWidget {
  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: bluegrey_dark,
      body: new FutureBuilder<List<Announcement>>(
          future: slackResources(),
          builder: (BuildContext context, AsyncSnapshot<List<Announcement>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(mintgreen_light), strokeWidth: 3.0,),
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
