import 'package:HackRU/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';

class Help extends StatelessWidget {
  @override
  Widget build (BuildContext context) => new Scaffold(
    backgroundColor: pink,
    body: new FutureBuilder<List<HelpResource>>(
      future: helpResources(MISC_URL),
      builder: (BuildContext context, AsyncSnapshot<List<HelpResource>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          return Center(
            child: new ColorLoader2(),
          );
          default:
          print(snapshot.hasError);
          var resources = snapshot.data;
          print(resources);
          return new Container(
            child: new ListView.builder(
              itemCount: resources.length,
              itemBuilder: (BuildContext context, int index) {
                return new HelpButton(resource: resources[index]);
              }
            )
          );
        }
      }
    )
  );
}

class HelpButton extends StatelessWidget {
  HelpButton({@required this.resource});
  final HelpResource resource;

  void _open() async {
    if (await canLaunch(resource.url)) {
      await launch(resource.url);
    } else {
      print("failed to launch url");
    }
  }

  Widget build (BuildContext context) => new Card(
      color: white,
      margin: EdgeInsets.all(10.0),
      elevation: 0.0,
      child: Container(
          height: 80.0,
          child: InkWell(
              splashColor: yellow,
              onTap: _open,
              child: new Row (
                  children: <Widget> [
                    Expanded(
                        child: new Text(
                            resource.name.toUpperCase(),
                            style: TextStyle(color: pink, fontSize: 25,),
                            textAlign: TextAlign.center
                        )
                    )
                  ]
              )
          )
      )
  );
}
