import 'package:hackru/models/models.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:flutter/material.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hackru/services/hackru_service.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

var count = 0;

class About extends StatefulWidget {
  const About({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool _hasAuthToken = false;
  bool isAuthorized = false;
  @override
  void initState() {
    super.initState();
    _hasToken();
    _getUserProfile();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void _getUserProfile() async {
    var _storedEmail = await getEmail();
    if (_storedEmail != "") {
      var _authToken = await getAuthToken();
      var userProfile = await getUser(_authToken!, _storedEmail!);
      if (userProfile.role.director == true ||
          userProfile.role.organizer == true) {
        setState(() {
          isAuthorized = true;
        });
      }
    }
  }

  void _hasToken() async {
    var hasToken = await hasCredentials();
    if (hasToken) {
      setState(() {
        _hasAuthToken = hasToken;
      });
    } else {
      setState(() {
        _hasAuthToken = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        controller: ScrollController(),
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/hackru-logos/hackru_red.png',
              semanticLabel: 'hackru logo',
              height: 250.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Made with',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                    const WidgetSpan(
                      child: FlutterLogo(size: 24.0),
                    ),
                    TextSpan(
                      text: 'Flutter & ❤️ by HackRU RnD Team',
                      style: TextStyle(
                        color: Colors.grey.shade800,
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
          if (_hasAuthToken && isAuthorized)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(1.0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 50.0,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: Text(
                  'Get attending',
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  _onGetAttending();
                },
              ),
            ),
          SizedBox(
            width: 100.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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

  Future _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible = false}) {
        return AlertDialog(
          backgroundColor: HackRUColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Icon(
            Icons.people,
            color: HackRUColors.off_white,
            size: 50.0,
          ),
          content: Text(body,
              style:
                  const TextStyle(fontSize: 50, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: HackRUColors.yellow,
              height: 40.0,
              color: HackRUColors.off_white,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  color: HackRUColors.pink,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onGetAttending() async {
    var _storedEmail = await getEmail();
    var _authToken = await getAuthToken();
    _getUserProfile();
    if (_hasAuthToken) {
      try {
        count = await getAttending(_authToken!);
        _scanDialogWarning("Total = " + count.toString());
      } on LcsError {
        var result = "Error Fetching Result.";
        _scanDialogWarning(result);
      }
    }
  }
}

class SocialMediaCard extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  const SocialMediaCard({Key? key, this.onPressed, this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        color: Theme.of(context).accentColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              iconData,
              color: HackRUColors.black,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
