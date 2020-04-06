import 'package:HackRU/blocs/login/login.dart';
import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/pages/about.dart';
import 'package:HackRU/ui/pages/help.dart';
import 'package:HackRU/ui/pages/home.dart';
import 'package:HackRU/ui/pages/map.dart';
import 'package:HackRU/ui/pages/scanner.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:HackRU/ui/widgets/custom_hidden_drawer_menu.dart';
import '../styles.dart';

class HackRUApp extends StatefulWidget {

  final LcsCredential lcsCredential;
  HackRUApp({Key key, this.lcsCredential}) : super(key: key);

  @override
  _HackRUAppState createState() => _HackRUAppState();
}

class _HackRUAppState extends State<HackRUApp> {
  List<ScreenHiddenDrawer> items = new List();
  bool _hasAuthToken = false;
  User user;

  void _hasToken() async{
    final bool hasToken = await hasCredentials();;
    setState(() {
      _hasAuthToken = hasToken;
    });
  }

  @override
  void initState() {
    _hasToken();
    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Home",
        baseStyle: TextStyle(
          color: grey,
          fontSize: 28.0,
        ),
        colorLineSelected: yellow,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      Home(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Map",
        baseStyle: TextStyle(color: grey, fontSize: 28.0),
        colorLineSelected: pink,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      HackRUMap(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Help",
        baseStyle: TextStyle(color: grey, fontSize: 28.0),
        colorLineSelected: yellow,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      Help(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "About",
        baseStyle: TextStyle(color: grey, fontSize: 28.0),
        colorLineSelected: pink,
        selectedStyle: TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
      ),
      About(),
    ));

    if (_hasAuthToken) {
      if (user.role["director"] == true ||
          user.role["volunteer"] == true ||
          user.role["organizer"] == true) {
        items.add(new ScreenHiddenDrawer(
          new ItemHiddenMenu(
            name: "QR Scanner",
            baseStyle: TextStyle(color: grey, fontSize: 28.0),
            colorLineSelected: yellow,
            selectedStyle:
            TextStyle(color: pink_dark, fontWeight: FontWeight.w500),
          ),
          QRScanner(),
        ));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHiddenDrawerMenu(
      actionsAppBar: (_hasAuthToken)
          ? <Widget>[
        IconButton(
          icon: Icon(
            GroovinMaterialIcons.logout,
            color: yellow,
          ),
          color: yellow,
          splashColor: white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (BuildContext context) => HackRUApp(),
                    maintainState: false),
                ModalRoute.withName('/main'));
            deleteCredentials();
          },
        ),
      ] : null,
//          : <Widget>[
//        IconButton(
//          icon: Icon(
//            GroovinMaterialIcons.login,
//            color: yellow,
//          ),
//          color: yellow,
//          splashColor: white,
//          onPressed: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => LoginPage(lcsCredential: widget.lcsCredential,)),
//            );
//          },
//        ),
//      ],
      iconMenuAppBar: Icon(
        Icons.menu,
        color: off_white,
      ),
      styleAutoTittleName: TextStyle(color: off_white),
      backgroundColorMenu: off_white,
      backgroundColorAppBar: pink,
      elevationAppBar: 0.0,
      backgroundMenu: FlareActor(
        'assets/flare/party.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "idle",
      ),
      screens: items,
      typeOpen: TypeOpen.FROM_LEFT,
    );
  }
}