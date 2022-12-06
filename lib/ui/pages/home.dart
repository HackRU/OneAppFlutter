import 'package:hackru/defaults.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcements.dart';
import 'package:hackru/ui/pages/dashboard/dashboard.dart';
import 'package:hackru/ui/pages/events/events.dart';
import 'package:hackru/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  static String? userEmail;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasAuthToken = false;
  int _currentBottomNavItemIndex = 1;
  CredManager? credManager;

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
    super.initState();
    _hasToken();
  }

  void _hasToken() async {
    var hasToken = credManager!.hasCredentials();
    if (hasToken) {
      setState(() {
        _hasAuthToken = hasToken;
      });
    } else {
      setState(() {
        _hasAuthToken = false;
      });
    }
  }

  ///===========================================================
  ///                     BOTTOM NAV PAGES
  ///===========================================================
  final _kBottomNavPages = <Widget>[Announcements(), Dashboard(), Events()];

  ///===========================================================
  ///                      BOTTOM APP BAR
  ///===========================================================
  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      elevation: 25.0,
      notchMargin: 6.0,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: InkResponse(
              onTap: () {
                setState(() {
                  _currentBottomNavItemIndex = 0;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.announcement,
                      size: 25.0,
                      color: _currentBottomNavItemIndex == 0
                          ? HackRUColors.white
                          : HackRUColors.charcoal_dark,
                    ),
                    Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: _currentBottomNavItemIndex == 0 ? 14.0 : 12.0,
                        color: _currentBottomNavItemIndex == 0
                            ? HackRUColors.white
                            : HackRUColors.charcoal_dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkResponse(
              onTap: () {
                setState(() {
                  _currentBottomNavItemIndex = 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.home,
                      size: 25.0,
                      color: _currentBottomNavItemIndex == 1
                          ? HackRUColors.white
                          : HackRUColors.charcoal_dark,
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: _currentBottomNavItemIndex == 1 ? 14.0 : 12.0,
                        color: _currentBottomNavItemIndex == 1
                            ? HackRUColors.white
                            : HackRUColors.charcoal_dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkResponse(
              onTap: () {
                setState(() {
                  _currentBottomNavItemIndex = 2;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.calendarAlt,
                      size: 25.0,
                      color: _currentBottomNavItemIndex == 2
                          ? HackRUColors.white
                          : HackRUColors.charcoal_dark,
                    ),
                    Text(
                      'Events',
                      style: TextStyle(
                        fontSize: _currentBottomNavItemIndex == 2 ? 14.0 : 12.0,
                        color: _currentBottomNavItemIndex == 2
                            ? HackRUColors.white
                            : HackRUColors.charcoal_dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///===========================================================
  ///                      SHOW QR-CODE
  ///===========================================================
  void _showQrCode() async {
    var userEmail = credManager!.getEmail();
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(15.0),
          //   ),
          // ),
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HackRUColors.white,
                    HackRUColors.white,
                  ],
                ),
              ),
              height: 400,
              width: 400.0,
              child: Center(
                child: QrImage(
                  version: 4,
                  data: userEmail ?? '',
                  gapless: true,
                  embeddedImage: const AssetImage(
                      'assets/hackru-logos/appIconImageWhite.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(50, 50),
                  ),
                  foregroundColor: HackRUColors.charcoal,
                ),
              ),
              // ListView(
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
              //       child: QrImage(
              //         version: 4,
              //         data: userEmail ?? '',
              //         gapless: true,
              //         foregroundColor: HackRUColors.charcoal,
              //       ),
              //     ),
              //     // Center(
              //     //   child: Text(userEmail ?? ''),
              //     // ),
              //   ],
              // ),
            ),
          ],
          backgroundColor: Colors.transparent,
        );
      },
    )) {
    }
  }

  ///===========================================================
  ///                     BUILD FUNCTION
  ///===========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _kBottomNavPages[_currentBottomNavItemIndex],
      floatingActionButton: _hasAuthToken
          ? Container()
          : FloatingActionButton(
              onPressed: () async {
                var loginResponse;
                var hasCred = credManager!.hasCredentials();
                if (hasCred) {
                  _showQrCode();
                } else {
                  loginResponse = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Provider.value(
                          value: credManager!, child: LoginPage()),
                      fullscreenDialog: true,
                    ),
                  );
                }
                if (loginResponse != null && loginResponse != '' && mounted) {
                  ScaffoldMessengerState().clearSnackBars();
                  ScaffoldMessengerState().showSnackBar(
                    SnackBar(
                      content: Text(loginResponse ?? ''),
                      backgroundColor: HackRUColors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              tooltip: 'QR Code',
              elevation: 4.0,
              splashColor: HackRUColors.white,
              isExtended: false,
              foregroundColor: HackRUColors.black,
              backgroundColor: Theme.of(context).accentColor,
              child: _hasAuthToken
                  ? const Icon(
                      FontAwesomeIcons.qrcode,
                      size: 22,
                    )
                  : Text("Login")),
      // Temporarily moving the login button
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }
}
