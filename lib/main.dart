import 'package:HackRU/screens/login.dart';
import 'package:HackRU/screens/scanner2.dart';
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
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/filestore.dart';
import 'package:HackRU/constants.dart';

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
        primaryColor: yellow,
        accentColor: yellow,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          fillColor: yellow,
          labelStyle: TextStyle(
            color: off_white,
          ),
        ),
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new Login(),
        '/main': (BuildContext context) => new MyHomePage(),
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
  var user = LoginState.guestUser;

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Home",
          baseStyle: TextStyle( color: grey, fontSize: 28.0, ),
          colorLineSelected: yellow,
          selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
        ),
        Home()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Map",
          baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
          colorLineSelected: pink,
          selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
        ),
        Map()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Help",
          baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
          colorLineSelected: yellow,
          selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
        ),
        Help()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "About",
          baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
          colorLineSelected: pink,
          selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
        ),
        About()));

    if(LoginState.credStr != '') {
      if (user.role["director"] == true) {
        items.add(new ScreenHiddenDrawer(
            new ItemHiddenMenu(
              name: "Scanner",
              baseStyle: TextStyle(color: grey, fontSize: 28.0),
              colorLineSelected: yellow,
              selectedStyle: TextStyle(
                  color: pink_dark, fontWeight: FontWeight.w500),
            ),
            QRScanner2()));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      actionsAppBar: (LoginState.credStr != '') ? <Widget>[
        IconButton(icon: Icon(GroovinMaterialIcons.logout, color: yellow,),
          color: yellow,
          splashColor: white,
          onPressed: (){
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute( builder: (BuildContext context) => MyHomePage()), ModalRoute.withName('/main'));
            deleteStoredCredential();
            LoginState.credStr = '';
        })
      ] : <Widget>[],
      tittleAppBar: Text('HackRU', style: TextStyle(color: off_white),),
      backgroundColorMenu: off_white,
      backgroundColorAppBar: pink,
      elevationAppBar: 0.0,
      backgroundMenu: DecorationImage(image: ExactAssetImage('assets/images/drawer_bg.png'),fit: BoxFit.cover),
      screens: items,
      iconMenuAppBar: Icon(Icons.arrow_back, color: off_white,),
    );

  }
}
