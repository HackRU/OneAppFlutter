import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HackRUApp extends StatefulWidget {
  const HackRUApp({Key? key}) : super(key: key);

  @override
  _HackRUAppState createState() => _HackRUAppState();
}

class _HackRUAppState extends State<HackRUApp> {
  bool _hasAuthToken = false;
  User? user;
  CredManager? credManager;

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
