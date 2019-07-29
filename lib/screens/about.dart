import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class About extends StatelessWidget {

  static const myIcons = <String, IconData> {
    'threesixty': Icons.threesixty,
    'threed_rotation': Icons.threed_rotation,
    'flutter': GroovinMaterialIcons.flutter,
  };

  @override
  Widget build (BuildContext context) => new Scaffold(
    backgroundColor: pink,
    body: new PageView(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset('assets/images/hackru_white_logo.png',
                alignment: Alignment.center,
                height: 150.0, width: 150.0,),
            ),
            ListTile(
              title: Text(
                  'The HackRU App is an open source effort made possible by the HackRU Research & Development Team. Hackers would be able to get announcements, a QR code for checking, food, etc. as well as see the schedule and map for the hackathon. Organizers would have an access to the QR Scanner.',
                  style: TextStyle(color: off_white,), textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15.0,),
            ListTile(
              leading: Icon(GroovinMaterialIcons.web, color: yellow,),
              title: Text('HackRU Website', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch('https://hackru.org/'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.github, color: yellow,),
              title: Text('Source code on GitHub', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch('https://github.com/HackRU/OneAppFlutter'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.facebookSquare, color: yellow,),
              title: Text('Like us on Facebook', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch('https://www.facebook.com/theHackRU/'),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.instagram, color: yellow,),
              title: Text('Follow us on Instagram', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch('https://www.instagram.com/thehackru/'),
            ),
            SizedBox(height: 15.0,),
          ],
        )
      ],
    ),
  );
}