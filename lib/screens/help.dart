import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
   void _launchHelp () async {
    const helpqUrl = 'https://hackru-helpq.herokuapp.com';
    if (await canLaunch(helpqUrl)) {
      await launch(helpqUrl);
    } else {
      print("failed to launch url");
    }
  }
  @override
  Widget build (BuildContext context) => new Scaffold(

    //Content of tabs
    body: new ListView(
      children: <Widget>[
        new Column(
          children: <Widget>[
            Card(
              color: pink_dark,
              margin: EdgeInsets.all(10.0),
              elevation: 0.0,
              child: Container(
                height: 80.0,
                child: InkWell(
                  splashColor: white,
                  onTap: (){this._launchHelp();},
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Get Help!',
                          style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 25,),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: mintgreen_dark,
              margin: EdgeInsets.all(10.0),
              elevation: 0.0,
              child: Container(
                height: 80.0,
                child: InkWell(
                  splashColor: white,
                  onTap: (){},
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Team Builder',
                          style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 25,),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: bluegrey,
              margin: EdgeInsets.all(10.0),
              elevation: 0.0,
              child: Container(
                height: 80.0,
                child: InkWell(
                  splashColor: white,
                  onTap: (){},
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('Devpost',
                          style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 25,),
                          textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        )
      ],
    ),
  );
}
