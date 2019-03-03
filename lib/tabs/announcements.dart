import 'package:HackRU/models.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'dart:async';
import 'dart:convert';
import 'package:HackRU/screens/string_parser.dart';
import 'package:HackRU/hackru_service.dart';


// Create a stateful widget
class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> {
  List data;
  Future<String> getJSONData() async {
    var response = await dayOfGetLcs('/dayof-slack');
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      data = dataConvertedToJSON['body'];
    });
    return "Data Received!";
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
                print(resources);
                return new Container(
                    child: new ListView.builder(
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index) {
                          String secs = data[index]['ts'].split(".")[0];
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
                                          new RichTextView(text: data[index]['text'] ?? ''),
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

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }

}