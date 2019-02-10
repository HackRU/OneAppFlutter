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

    //App Bar
//    appBar: new AppBar(
//      backgroundColor: bluegrey,
//      title: new Text(
//        'About HackRU',
//        style: new TextStyle(
//          fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
//        ),
//      ),
//      elevation: 0.3,
//    ),

    //Content of tabs
    body: new PageView(
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: Text("Get Help!"),
              color: pink_dark,
              textColor: white,
              textTheme: ButtonTextTheme.normal,
              elevation: 6.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              onPressed: this._launchHelp
            ),
          ],
        )
      ],
    ),
  );
}
