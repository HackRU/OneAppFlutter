import 'package:HackRU/blocs/login/login.dart';
import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/ui/pages/tabs/announcements.dart' as _firstTab;
import 'package:HackRU/ui/pages/tabs/events.dart' as _thirdTab;
import 'package:HackRU/ui/pages/tabs/timer.dart' as _secondTab;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';
  static String userEmail;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  int _tab = 0;
  var _title_app = null;
  var _title_icon = null;
  PageController _tabController;
  String userEmailAddr;
  LcsCredential _credentials;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;

    getEmail().then((email) {
      if (email != null) {
        userEmailAddr = email;
      }
    });
  }

  void onTap(int tab) {
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState(() {
      this._tab = tab;
    });

    switch (tab) {
      case 0:
        this._title_app = TabItems[0].title;
        break;
      case 1:
        this._title_app = TabItems[1].title;
        break;
      case 2:
        this._title_app = TabItems[2].title;
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavBar = BottomNavigationBar(
      items: TabItems.map((TabItem) {
        return new BottomNavigationBarItem(
          backgroundColor: off_white,
          title: new Text(
            TabItem.title,
          ),
          icon: new Icon(
            TabItem.icon,
            color: pink,
          ),
        );
      }).toList(),
      currentIndex: _tab,
      type: _type,
      onTap: onTap,
      fixedColor: pink,
    );

    return Scaffold(
      body: new PageView(
        controller: _tabController,
        onPageChanged: onTabChanged,
        children: <Widget>[
          new _firstTab.Announcements(),
          new _secondTab.Timer(),
          new _thirdTab.Events(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var hasCred = await hasCredentials();
          (hasCred) ? _qrCode()
            : Navigator.push(context, MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
        },
        tooltip: 'QR Code',
        child: Icon(
          GroovinMaterialIcons.qrcode,
          size: 30,
        ),
        foregroundColor: black,
        backgroundColor: Theme.of(context).accentColor,
      ),
      bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
          ? new CupertinoTabBar(
              backgroundColor: off_white,
              activeColor: pink,
              currentIndex: _tab,
              onTap: onTap,
              inactiveColor: grey,
              items: TabItems.map((TabItem) {
                return new BottomNavigationBarItem(
                  title: new Text(TabItem.title),
                  icon: new Icon(TabItem.icon),
                );
              }).toList(),
            )
          : bottomNavBar,
    );
  }

  Future<Null> _qrCode() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            Container(
              height: 300.0,
              width: 300.0,
              child: Center(
                child: QrImage(
                  version: 4,
                  data: userEmailAddr,
                  gapless: true,
                  foregroundColor: pink,
                ),
              ),
            ),
          ],
          backgroundColor: off_white,
        );
      },
    )) {
    }
  }
}

class TabItem {
  const TabItem({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(
    title: 'Announcements',
    icon: GroovinMaterialIcons.message_alert,
  ),
  const TabItem(
    title: 'Timer',
    icon: GroovinMaterialIcons.timer,
  ),
  const TabItem(
    title: 'Events',
    icon: GroovinMaterialIcons.calendar_today,
  ),
];
