import 'package:HackRU/blocs/login/login.dart';
import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/ui/pages/about_app/about.dart';
import 'package:HackRU/ui/pages/help/help.dart';
import 'package:HackRU/ui/pages/home.dart';
import 'package:HackRU/ui/pages/floor_map/map.dart';
import 'package:HackRU/ui/pages/qr_scanner/QRScanner.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer/screen_hidden_drawer.dart';
import 'package:hidden_drawer_menu/menu/item_hidden_menu.dart';
import 'package:HackRU/ui/widgets/custom_hidden_drawer_menu.dart';
import '../styles.dart';

class HackRUApp extends StatefulWidget {
  HackRUApp({Key key}) : super(key: key);

  @override
  _HackRUAppState createState() => _HackRUAppState();
}

class _HackRUAppState extends State<HackRUApp> {
  List<ScreenHiddenDrawer> items = new List();
  bool _hasAuthToken = false;
  User user;

  TextStyle _selectedDrawerItem = TextStyle(color: pink, fontWeight: FontWeight.w700);
  TextStyle _nonSelectedDrawerItem = TextStyle(color: grey, fontSize: 28.0, fontWeight: FontWeight.w500);

  @override
  void initState() {
    _hasToken();
    if(_hasAuthToken != null) _drawerItems();
    super.initState();
  }

  /// =========================================================
  ///                     CREDENTIAL MANAGER
  /// =========================================================
  void _hasToken() async{
    var hasToken = await hasCredentials();
    if(hasToken){
      setState(() {
        _hasAuthToken = hasToken;
      });
      _getUserProfile();
    } else{
      setState(() {
        _hasAuthToken = false;
      });
    }
  }

  void _getUserProfile() async {
    var _storedEmail = await getEmail();
    var _authToken = await getAuthToken();
    var userProfile = await getUser(_authToken, _storedEmail);
    print('====== Email: ${userProfile.email} ======');
    if(userProfile != null){
      setState(() {
        user = userProfile;
      });
    }
  }

  /// =========================================================
  ///                      DRAWER ITEMS
  /// =========================================================
  void _drawerItems(){
    setState(() {});
    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Home",
        baseStyle: _nonSelectedDrawerItem,
        colorLineSelected: yellow,
        selectedStyle: _selectedDrawerItem,
      ),
      Home(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Map",
        baseStyle: _nonSelectedDrawerItem,
        colorLineSelected: yellow,
        selectedStyle: _selectedDrawerItem,
      ),
      HackRUMap(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "Help",
        baseStyle: _nonSelectedDrawerItem,
        colorLineSelected: yellow,
        selectedStyle: _selectedDrawerItem,
      ),
      Help(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "About",
        baseStyle: _nonSelectedDrawerItem,
        colorLineSelected: yellow,
        selectedStyle: _selectedDrawerItem,
      ),
      About(),
    ));

    items.add(new ScreenHiddenDrawer(
      new ItemHiddenMenu(
        name: "QR Scanner",
        baseStyle: _nonSelectedDrawerItem,
        colorLineSelected: yellow,
        selectedStyle: _selectedDrawerItem,
      ),
      QRScanner(),
    ));

    /// TODO: Fix this
//    if (!_hasAuthToken) {
//      if (user?.role?.director == true ||
//          user?.role?.volunteer == true ||
//          user?.role?.organizer == true) {
//        items.add(new ScreenHiddenDrawer(
//          new ItemHiddenMenu(
//            name: "QR Scanner",
//            baseStyle: _nonSelectedDrawerItem,
//            colorLineSelected: yellow,
//            selectedStyle: _selectedDrawerItem,
//          ),
//          QRScanner(),
//        ));
//      }
//    }

    if (_hasAuthToken) {
      items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Logout",
          baseStyle: _nonSelectedDrawerItem,
          colorLineSelected: yellow,
          selectedStyle: _selectedDrawerItem,
          onTap: () async {
            await deleteCredentials();
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
              builder: (BuildContext context) => HackRUApp(),
              maintainState: false,
            ),
              ModalRoute.withName('/main'),
            );
          },
        ),
        Container(),
      ));
    }

  }

  /// =========================================================
  ///                     BUILD FUNCTION
  /// =========================================================

  @override
  Widget build(BuildContext context) {
    print('==**==== $_hasAuthToken ===**===');
    return CustomHiddenDrawerMenu(
      actionsAppBar: <Widget>[
        _hasAuthToken ? IconButton(
          icon: Icon(
            GroovinMaterialIcons.logout,
            color: Theme.of(context).primaryColor,
          ),
          color: transparent,
          splashColor: yellow,
          onPressed: () async {
            await deleteCredentials();
            setState(() {
              _hasAuthToken = false;
            });
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
              builder: (BuildContext context) => HackRUApp(),
              maintainState: false,
            ),
              ModalRoute.withName('/main'),
            );
          },
        ) : Container(),
      ],
      iconMenuAppBar: Icon(
        Icons.menu,
        color: grey,
      ),
      styleAutoTittleName: Theme.of(context).textTheme.title,
      backgroundColorMenu: grey,
      backgroundColorAppBar: Theme.of(context).backgroundColor,
      elevationAppBar: 0.0,
      backgroundMenu: Container(
        color: charcoal,
        child: FlareActor(
          'assets/flare/party.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "idle",
        ),
      ),
      screens: items,
      typeOpen: TypeOpen.FROM_LEFT,
    );
  }
}