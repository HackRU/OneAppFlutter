import 'package:HackRU/defaults.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/hackru_app.dart';
import 'package:HackRU/ui/pages/floor_map/map.dart';
import 'package:HackRU/ui/pages/login/login_page.dart';
import 'package:HackRU/ui/widgets/page_not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'styles.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final LcsCredential lcsCredential;
  const MainApp({Key key, this.lcsCredential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: HackRUApp(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HackRUApp(),
        '/floorMap': (BuildContext context) => HackRUMap(),
      },
      onUnknownRoute: (RouteSettings setting) {
        var unknownRoute = setting.name;
        return MaterialPageRoute(
          builder: (context) => PageNotFound(
            title: unknownRoute,
          ),
        );
      },
    );
  }
}
