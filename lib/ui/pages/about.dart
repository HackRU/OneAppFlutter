import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        backgroundColor: pink,
        body: ListView(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/hackru-logos/hackru_white.png',
                    alignment: Alignment.center,
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
                ListTile(
                  title: Text(
                    kAboutApp,
                    style: TextStyle(
                      color: off_white,
                    ),
                    textAlign: TextAlign.center,
                    strutStyle: StrutStyle(
                      fontSize: 14,
                      forceStrutHeight: true,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                ListTile(
                  leading: Icon(
                    GroovinMaterialIcons.web,
                    color: yellow,
                  ),
                  title: Text('HackRU Website',
                      style: TextStyle(
                        color: off_white,
                      )),
                  onTap: () => url_launcher.launch(HACK_RU_WEBSITE_URL),
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.github,
                    color: yellow,
                  ),
                  title: Text('Source code on GitHub',
                      style: TextStyle(
                        color: off_white,
                      )),
                  onTap: () => url_launcher.launch(REPOSITORY_URL),
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.facebookSquare,
                    color: yellow,
                  ),
                  title: Text('Like us on Facebook',
                      style: TextStyle(
                        color: off_white,
                      )),
                  onTap: () => url_launcher.launch(FACEBOOK_PAGE_URL),
                ),
                ListTile(
                  leading: Icon(
                    FontAwesomeIcons.instagram,
                    color: yellow,
                  ),
                  title: Text('Follow us on Instagram',
                      style: TextStyle(
                        color: off_white,
                      )),
                  onTap: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            )
          ],
        ),
      );
}
