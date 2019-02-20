import 'package:HackRU/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/tabs/announcements.dart' as _firstTab;
import 'package:HackRU/tabs/timer.dart' as _secondTab;
import 'package:HackRU/tabs/events.dart' as _thirdTab;
import 'package:groovin_material_icons/groovin_material_icons.dart';

class Home extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with TickerProviderStateMixin {
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  int _tab = 0;
  var _title_app = null;
  var _title_icon = null;
  PageController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }

  void onTap(int tab){
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState((){
      this._tab = tab;
    });

    switch (tab) {
      case 0:   this._title_app = TabItems[0].title; break;
      case 1:   this._title_app = TabItems[1].title; break;
      case 2:   this._title_app = TabItems[2].title; break;
    }
  }

  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavBar = BottomNavigationBar(
      items: TabItems.map((TabItem) {
        return new BottomNavigationBarItem(
          backgroundColor: bluegrey_dark,
          title: new Text(TabItem.title),
          icon: new Icon(TabItem.icon),
        );
      }).toList(),
      currentIndex: _tab,
      type: _type,
      onTap: onTap,
      fixedColor: mintgreen_light,
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
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          tooltip: 'QR Code',
          child: Icon(GroovinMaterialIcons.qrcode, size: 30,),
          foregroundColor: mintgreen_light,
          backgroundColor: bluegrey,
      ),
      bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS ?
      new CupertinoTabBar(
        backgroundColor: bluegrey_dark,
        activeColor: mintgreen_light,
        currentIndex: _tab,
        onTap: onTap,
        items: TabItems.map((TabItem) {
          return new BottomNavigationBarItem(
            title: new Text(TabItem.title),
            icon: new Icon(TabItem.icon),
          );
        }).toList(),
      ):
        bottomNavBar,
    );
  }


  Future<Null> _qrcode() async {
    switch(await showDialog(
        context: context,
        builder: (BuildContext) {
          new SimpleDialog(
            title: new Text('Username'),
            children: <Widget>[
              new Image.asset('assets/images/hackru_qrcode.png',
                fit: BoxFit.fill,
              )
            ],
          );
        })
    ){}
  }

}



class TabItem {
  const TabItem({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Announcements', icon: GroovinMaterialIcons.message_alert,),
  const TabItem(title: 'Timer', icon: GroovinMaterialIcons.timer,),
  const TabItem(title: 'Events', icon: GroovinMaterialIcons.calendar_today,),
];