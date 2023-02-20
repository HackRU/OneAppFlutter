import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

const helpResources = [
  {
    "name": "MentorQ",
    "desc": "Get matched with a mentor for help!",
    "url": HELP_Q_URL
  },
  {
    "name": "Slack",
    "desc": "Talk to friends, mentors, and organizers at HackRU",
    "url": SLACK_PAGE_URL
  },
  {
    "name": "Devpost",
    "desc": "Submit your projects",
    "url": DEVPOST_URL,
  },
  {
    "name": "Rutgers Campus Map",
    "desc": "Rutgers University - College Ave Campus",
    "url":
        "https://maps.rutgers.edu/#/?bus=true&dining=true&healthCare=true&lat=40.503942&lng=-74.450773&parking=true&sidebar=true&zoom=17"
  },
  {
    "name": "Register Your Vehicle",
    "desc": "Register for free parking permit",
    "url":
        "https://rudots.nupark.com/v2/portal/eventregister/e205e56c-4a65-4055-804f-16cbc270bf21#/events/registration/"
  }
];

class Help extends StatelessWidget {
  Help(this.toggleHelp, this.bgColor, this.textColor, this.buttonColor,
      this.splashColor);
  VoidCallback toggleHelp;
  Color bgColor;
  Color textColor;
  Color buttonColor;
  Color splashColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: toggleHelp,
            icon: Icon(Icons.close),
            color: textColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: helpResources.length,
        itemBuilder: (BuildContext context, int index) {
          HelpResource helpResource =
              HelpResource.fromJson(helpResources[index]);
          return HelpButton(
            resource: helpResource,
            bgColor: buttonColor,
            splashColor: splashColor,
            textColor: textColor,
          );
        },
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  HelpButton(
      {required this.resource,
      required this.bgColor,
      required this.splashColor,
      required this.textColor});
  final HelpResource resource;
  final Color bgColor;
  final Color splashColor;
  final Color textColor;

  void _open() async {
    if (await canLaunchUrlString(resource.url)) {
      await launchUrlString(resource.url);
    } else {
      print('failed to launch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      elevation: 0.0,
      child: Container(
        height: 120.0,
        child: InkWell(
          splashColor: splashColor,
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
                        color: textColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        resource.description,
                        style: TextStyle(
                          color: textColor,
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
}
