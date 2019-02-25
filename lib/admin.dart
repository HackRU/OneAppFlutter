import 'package:HackRU/screens/login.dart';
import 'package:HackRU/screens/scanner.dart';
import 'package:HackRU/screens/scanner2.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'colors.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:HackRU/screens/about.dart';
import 'package:HackRU/screens/map.dart';
import 'package:HackRU/screens/help.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:HackRU/screens/home.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<ScreenHiddenDrawer> items = new List();

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Home",
          colorTextUnSelected: white.withOpacity(0.5),
          colorLineSelected: mintgreen_light,
        ),
        Home()));

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
        QRScanner2()));

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
      actionsAppBar: <Widget>[
        IconButton(icon: Icon(GroovinMaterialIcons.logout, color: pink_light,), color: pink_light, splashColor: pink_light, onPressed: (){Navigator.pop(context);})

      ],
      backgroundColorMenu: bluegrey_dark,
      backgroundColorAppBar: bluegrey_dark,
      elevationAppBar: 0,
      backgroundMenu: DecorationImage(image: ExactAssetImage('assets/images/drawer_bg.png'),fit: BoxFit.cover),
      screens: items,
    );

  }
}