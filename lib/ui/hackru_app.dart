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

  @override
  Widget build(BuildContext context) {
    debugPrint('==**==== HAS_AUTH_TOKEN: $_hasAuthToken ===**===');
    return Home();
  }
}
