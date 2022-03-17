import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/hackru-logos/hackru_red.png',
              height: 250.0,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              kAboutApp,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.all(25.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Made with',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                    WidgetSpan(
                      child: FlutterLogo(size: 24.0),
                    ),
                    TextSpan(
                      text: 'Flutter & ❤️ by HackRU RnD Team',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(HACK_RU_WEBSITE_URL),
                  iconData: FontAwesomeIcons.link,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(REPOSITORY_URL),
                  iconData: FontAwesomeIcons.github,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(FACEBOOK_PAGE_URL),
                  iconData: FontAwesomeIcons.facebookSquare,
                ),
                SocialMediaCard(
                  onPressed: () => url_launcher.launch(INSTAGRAM_PAGE_URL),
                  iconData: FontAwesomeIcons.instagram,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialMediaCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  const SocialMediaCard({Key? key, this.onPressed, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            iconData,
            color: black,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
