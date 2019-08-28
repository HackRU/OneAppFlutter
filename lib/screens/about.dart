import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HackRU/constants.dart';


class About extends StatelessWidget {

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
                ABOUT_HACKRU,
                style: TextStyle(color: off_white,), textAlign: TextAlign.center,
                strutStyle: StrutStyle(
                  fontSize: 14,
                  forceStrutHeight: true,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 15.0,),
            ListTile(
              leading: Icon(GroovinMaterialIcons.web, color: yellow,),
              title: Text('HackRU Website', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch(HACKRU_PAGE_URL),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.github, color: yellow,),
              title: Text('Source code on GitHub', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch(REPOSITORY_URL),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.facebookSquare, color: yellow,),
              title: Text('Like us on Facebook', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch(FACEBOOK_PAGE_URL),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.instagram, color: yellow,),
              title: Text('Follow us on Instagram', style: TextStyle(color: off_white,)),
              onTap: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
            ),
            SizedBox(height: 15.0,),
          ],
        )
      ],
    ),
  );
}