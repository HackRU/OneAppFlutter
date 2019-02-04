import 'package:HackRU/screens/qrcode.dart';
import 'package:HackRU/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'colors.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:HackRU/screens/tabs.dart';
import 'package:HackRU/screens/about.dart';
import 'package:HackRU/screens/map.dart';
import 'package:HackRU/screens/help.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackRU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: bluegrey_dark,
        accentColor: mintgreen_light,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScreenHiddenDrawer> items = new List();

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Home",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: mintgreen_light,
        ),
        Tabs()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Map",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: pink_light,
        ),
        Map()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Scanner",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: mintgreen_dark,
        ),
        QRScanner()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "QR Code",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: mintgreen_dark,
        ),
        QRCode()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Help",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: mintgreen_dark,
        ),
        Help()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "About",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: pink_dark,
        ),
        About()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: bluegrey_dark,
      backgroundColorAppBar: bluegrey_dark,
      elevationAppBar: 0,
      backgroundMenu: DecorationImage(image: ExactAssetImage('assets/images/drawer_bg.png'),fit: BoxFit.cover),
      screens: items,
    );

  }
}