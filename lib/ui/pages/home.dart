import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/ui/pages/dashboard/dashboard.dart';
import 'package:HackRU/ui/pages/events/events.dart';
import 'package:HackRU/ui/pages/login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
//import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  static String userEmail;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavItemIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  ///===========================================================
  ///                     BOTTOM NAV PAGES
  ///===========================================================
  final _kBottomNavPages = <Widget>[
    Dashboard(),
    Events(),
  ];

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
                      Icons.home,
                      size: 25.0,
                      color: _currentBottomNavItemIndex == 0
                          ? white
                          : charcoal_dark,
                    ),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: _currentBottomNavItemIndex == 0 ? 14.0 : 12.0,
                        color: _currentBottomNavItemIndex == 0
                            ? white
                            : charcoal_dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
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
                      GroovinMaterialIcons.calendar_clock,
                      size: 25.0,
                      color: _currentBottomNavItemIndex == 1
                          ? white
                          : charcoal_dark,
                    ),
                    Text(
                      'Events',
                      style: TextStyle(
                        fontSize: _currentBottomNavItemIndex == 1 ? 14.0 : 12.0,
                        color: _currentBottomNavItemIndex == 1
                            ? white
                            : charcoal_dark,
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
    /*var userEmail = await getEmail();
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          children: <Widget>[
            Container(
              height: 340.0,
              width: 400.0,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: QrImage(
                      version: 4,
                      data: userEmail ?? '',
                      gapless: true,
                      foregroundColor: charcoal,
                    ),
                  ),
                  Center(
                    child: Text(userEmail ?? ''),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: white,
        );
      },
    )) {
    }*/
  }

  ///===========================================================
  ///                     BUILD FUNCTION
  ///===========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _kBottomNavPages[_currentBottomNavItemIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var loginResponse;
          var hasCred = await hasCredentials();
          if (hasCred) {
            _showQrCode();
          } else {
            loginResponse = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
                fullscreenDialog: true,
              ),
            );
          }
          if (loginResponse != null && loginResponse != '') {
            _scaffoldKey.currentState
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(loginResponse ?? ''),
                  backgroundColor: green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        child: Icon(
          GroovinMaterialIcons.qrcode,
          size: 34,
        ),
        tooltip: 'QR Code',
        elevation: 4.0,
        splashColor: white,
        isExtended: false,
        foregroundColor: black,
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }
}
