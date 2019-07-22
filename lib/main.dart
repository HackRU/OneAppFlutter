import 'package:HackRU/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'colors.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:HackRU/screens/about.dart';
import 'package:HackRU/screens/map.dart';
import 'package:HackRU/screens/help.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/filestore.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackRU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: pink,
        accentColor: green,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          fillColor: greyLight,
          labelStyle: TextStyle(
            color: greyLight,
          ),
        ),
      ),
      home: Login(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new Login(),
      },
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
          baseStyle: TextStyle( color: white.withOpacity(0.5), fontSize: 28.0 ),
          colorLineSelected: yellow,
        ),
        Home()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Map",
          baseStyle: TextStyle( color: white.withOpacity(0.5), fontSize: 28.0 ),
          colorLineSelected: pink,
        ),
        Map()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Help",
          baseStyle: TextStyle( color: white.withOpacity(0.5), fontSize: 28.0 ),
          colorLineSelected: yellow,
        ),
        Help()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "About",
          baseStyle: TextStyle( color: white.withOpacity(0.5), fontSize: 28.0 ),
          colorLineSelected: pink,
        ),
        About()));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      actionsAppBar: <Widget>[
        IconButton(icon: Icon(GroovinMaterialIcons.logout, color: pink,),
          color: pink,
          splashColor: yellow,
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute( builder: (BuildContext context) => Login()), ModalRoute.withName('/login'));
            deleteStoredCredential();
        })
      ],
      backgroundColorMenu: charcoal,
      backgroundColorAppBar: charcoal,
      elevationAppBar: 0,
      backgroundMenu: DecorationImage(image: ExactAssetImage('assets/images/drawer_bg.png'),fit: BoxFit.cover),
      screens: items,
      iconMenuAppBar: Icon(Icons.arrow_back, color: green,),
    );

  }
}
