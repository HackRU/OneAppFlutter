import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:HackRU/screens/string_parser.dart';


// Create a stateful widget
class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> {
  final String url = "https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest/dayof-slack";
  List data;

  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      // Get the JSON data
      var dataConvertedToJSON = json.decode(response.body);
      data = dataConvertedToJSON['body'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bluegrey_dark,
      // Create a Listview and load the data when available
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Card(
                        child: new Container(
                          // Customized URL Launcher
                          child: new RichTextView(text: data[index]['text'] ?? ''),

                          // URL Launcher Library
                          //child: new Linkify(
//                            onOpen: (url) async {if (await canLaunch(url)) {await launch(url);} else {throw 'Could not launch $url';}},
//                            text: data[index]['text'] ?? '',
//                            style: TextStyle(fontSize: 15.0, color: bluegrey_dark,),
//                            linkStyle: TextStyle(color: green_tab),
//                          ),
                          padding: const EdgeInsets.all(15.0),
                        ),
                        elevation: 5.0,
                      )
                    ],
                  )
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getJSONData();
  }
}