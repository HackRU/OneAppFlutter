import 'package:HackRU/colors.dart';
import 'package:HackRU/constants.dart';
import 'package:HackRU/models/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        backgroundColor: pink,
        body: new FutureBuilder<List<HelpResource>>(
          future: helpResources(MISC_URL),
          builder: (BuildContext context,
              AsyncSnapshot<List<HelpResource>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Container(
                    color: transparent,
                    height: 400.0,
                    width: 400.0,
                    child: FlareActor(
                      'assets/loading_indicator.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "idle",
                    ),
                  ),
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
                    },
                  ),
                );
            }
          },
        ),
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

  Widget build(BuildContext context) => new Card(
        color: off_white,
        margin: EdgeInsets.all(10.0),
        elevation: 0.0,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: yellow,
            onTap: _open,
            child: new Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        resource.name.toUpperCase(),
                        style: TextStyle(
                            color: pink,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      new Text(
                        resource.description,
                        style: TextStyle(
                            color: pink,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
