import 'package:HackRU/foodScanner/foodTracker.dart';
import 'package:HackRU/screens/login.dart';
import 'package:HackRU/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:HackRU/screens/about.dart';
import 'package:HackRU/screens/map.dart';
import 'package:HackRU/screens/help.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:HackRU/screens/home.dart';
import 'package:HackRU/filestore.dart';
import 'colors.dart';

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
//      onUnknownRoute: (RouteSettings setting) {
//        String unknownRoute = setting.name ;
//        return new MaterialPageRoute(
//            builder: (context) => NotFoundPage()
//        );
//      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.initPositionSelected}) : super(key: key);

  final int initPositionSelected;

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
      Home(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Map",
        baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
        colorLineSelected: pink,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      Map(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Help",
        baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
        colorLineSelected: yellow,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      Help(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "About",
        baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
        colorLineSelected: pink,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      About(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Food Tracker",
        baseStyle: TextStyle( color: grey, fontSize: 28.0 ),
        colorLineSelected: yellow,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      FoodTracker(),
    ));

    if(LoginState.credStr != '') {
      if (user.role["director"] == true) {
        items.add(new ScreenHiddenDrawer(
          new ItemHiddenMenu(
            name: "QR Scanner",
            baseStyle: TextStyle(color: grey, fontSize: 28.0),
            colorLineSelected: yellow,
            selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
          ),
          QRScanner(),
        ));
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
        }),
      ] : <Widget>[],
      iconMenuAppBar: Icon(Icons.arrow_back, color: off_white,),
      styleAutoTittleName: TextStyle(color: off_white),
      backgroundColorMenu: off_white,
      backgroundColorAppBar: pink,
      elevationAppBar: 0.0,
      backgroundMenu: DecorationImage(image: ExactAssetImage('assets/images/drawer_bg.png'),fit: BoxFit.cover),
      screens: items,
    );

  }

}

