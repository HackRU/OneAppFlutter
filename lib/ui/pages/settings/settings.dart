import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isDarkMode = false;
  bool allowPushNotifications = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          SwitchListTile(
            title: Text('Dark Mode'),
            secondary: Icon(Icons.lightbulb_outline, size: 30,),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            }
          ),
          SwitchListTile(
            title: Text('Push Notifications'),
            secondary: Icon(Icons.notifications, size: 30,),
            value: allowPushNotifications,
            onChanged: (value) {
              setState(() {
                allowPushNotifications = value;
              });
            }
          ),
        ],),
    );
  }
}
