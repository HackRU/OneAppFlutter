import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<HelpResource>>(
        future: helpResources(MISC_URL),
        builder:
            (BuildContext context, AsyncSnapshot<List<HelpResource>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  color: HackRUColors.transparent,
                  height: 400.0,
                  width: 400.0,
                  child: FlareActor(
                    'assets/flare/loading_indicator.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: 'idle',
                  ),
                ),
              );
            default:
              print(snapshot.hasError);
              var resources = snapshot.data;
//              print(resources);
              return Container(
                child: ListView.builder(
                  itemCount: resources?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HelpButton(resource: resources![index]);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  HelpButton({required this.resource});
  final HelpResource resource;

  void _open() async {
    if (await canLaunch(resource.url)) {
      await launch(resource.url);
    } else {
      print('failed to launch url');
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 0.0,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: HackRUColors.yellow,
            onTap: _open,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        resource.name.toUpperCase(),
                        style: TextStyle(
                          color: HackRUColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          resource.description,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
