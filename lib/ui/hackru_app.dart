import 'package:flutter/scheduler.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/ui/pages/about_app/about.dart';
import 'package:hackru/ui/pages/help/help.dart';
import 'package:hackru/ui/pages/home.dart';
import 'package:hackru/ui/pages/qr_scanner/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hackru/ui/widgets/custom_hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

class HackRUApp extends StatefulWidget {
  const HackRUApp({Key? key}) : super(key: key);

  @override
  _HackRUAppState createState() => _HackRUAppState();
}

class _HackRUAppState extends State<HackRUApp> {
  List<ScreenHiddenDrawer> items = [];
  bool _hasAuthToken = false;
  User? user;
  CredManager? credManager;

  final _selectedDrawerItem = const TextStyle(
    color: HackRUColors.pink,
    fontWeight: FontWeight.w700,
  );
  final _nonSelectedDrawerItem = const TextStyle(
    color: HackRUColors.grey,
    fontSize: 28.0,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    setState(() {
      credManager = Provider.of<CredManager>(context, listen: false);
    });

    _hasToken();
    _drawerItems();
    super.initState();
  }

  /// =========================================================
  ///                     CREDENTIAL MANAGER
  /// =========================================================
  void _hasToken() {
    var hasToken = credManager!.hasCredentials();
    if (hasToken) {
      setState(() {
        _hasAuthToken = hasToken;
      });
      _getUserProfile();
    } else {
      setState(() {
        _hasAuthToken = false;
      });
    }
  }

  void _getUserProfile() async {
    var _storedEmail = credManager!.getEmail();
    if (_storedEmail != "") {
      var _authToken = credManager!.getAuthToken();
      var userProfile = await getUser(_authToken, _storedEmail);
      if (userProfile != null) {
        if (mounted) {
          setState(() {
            user = userProfile;
          });
        }
      }
    }
  }

  /// =========================================================
  ///                      DRAWER ITEMS
  /// =========================================================
  void _drawerItems() {
    setState(() {});
    items = [];
    items.add(ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Home',
          baseStyle: _nonSelectedDrawerItem,
          colorLineSelected: HackRUColors.yellow,
          selectedStyle: _selectedDrawerItem,
        ),
        Provider.value(
          value: credManager,
          child: Home(),
        )));

    // items.add(ScreenHiddenDrawer(
    //   ItemHiddenMenu(
    //     name: 'Map',
    //     baseStyle: _nonSelectedDrawerItem,
    //     colorLineSelected: HackRUColors.yellow,
    //     selectedStyle: _selectedDrawerItem,
    //   ),
    //   HackRUMap(),
    // ));

    items.add(
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Help',
            baseStyle: _nonSelectedDrawerItem,
            colorLineSelected: HackRUColors.yellow,
            selectedStyle: _selectedDrawerItem,
          ),
          Provider.value(value: credManager, child: Help())),
    );

    items.add(
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'About',
            baseStyle: _nonSelectedDrawerItem,
            colorLineSelected: HackRUColors.yellow,
            selectedStyle: _selectedDrawerItem,
          ),
          Provider.value(value: credManager, child: About())),
    );

    //NOTE: only show QR_SCANNER button to authorized users
    items.add(
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: "QR Scanner",
            baseStyle: _nonSelectedDrawerItem,
            colorLineSelected: HackRUColors.yellow,
            selectedStyle: _selectedDrawerItem,
          ),
          Provider.value(value: credManager, child: QRScanner())),
    );
  }

  /// =========================================================
  ///                     BUILD FUNCTION
  /// =========================================================

  @override
  Widget build(BuildContext context) {
    debugPrint('==**==== HAS_AUTH_TOKEN: $_hasAuthToken ===**===');
    return CustomHiddenDrawerMenu(
      actionsAppBar: <Widget>[
        // ====== REFRESH DATA - MANUALLY
        IconButton(
          icon: Icon(
            Icons.refresh_rounded,
            color: Colors.grey[500],
          ),
          color: HackRUColors.transparent,
          splashColor: HackRUColors.yellow,
          onPressed: () {
            // setState(() {});
            _hasToken();
            _drawerItems();
          },
        ),
        const SizedBox(width: 8),
        // ====== LOGOUT BUTTON
        _hasAuthToken
            ? IconButton(
                tooltip: 'Logout',
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                color: HackRUColors.transparent,
                splashColor: HackRUColors.yellow,
                onPressed: () async {
                  credManager!.deleteCredentials();
                  setState(() {
                    _hasAuthToken = false;
                  });
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Provider.value(
                          value: credManager!, child: HackRUApp()),
                      maintainState: false,
                    ),
                    ModalRoute.withName('/main'),
                  );
                },
              )
            : Container(),
      ],
      leadingAppBar: const Icon(
        Icons.menu,
        color: HackRUColors.grey,
      ),
      styleAutoTittleName: Theme.of(context).textTheme.headline6,
      backgroundColorMenu: HackRUColors.grey,
      backgroundColorAppBar: Theme.of(context).backgroundColor,
      elevationAppBar: 0.0,
      backgroundMenu: Container(
        color: HackRUColors.charcoal,
        // child: const RiveAnimation.asset(
        //   'assets/flare/party.flr',
        //   alignment: Alignment.center,
        //   fit: BoxFit.contain,
        //   animations: ['idle'],
        // ),
      ),
      screens: items,
      typeOpen: TypeOpen.FROM_LEFT,
    );
  }
}
