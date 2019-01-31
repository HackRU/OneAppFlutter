import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/tabs/announcements.dart' as _firstTab;
import 'package:HackRU/tabs/timer.dart' as _secondTab;
import 'package:HackRU/tabs/events.dart' as _thirdTab;
import 'package:HackRU/screens/login.dart';

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> {

  PageController _tabController;

  var _title_app = null;
  var _title_icon = null;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    this._title_app = TabItems[0].title;
  }



  @override
  Widget build (BuildContext context) => new Scaffold(

    //Content of tabs
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
        child: Icon(GroovinMaterialIcons.qrcode),
        foregroundColor: mintgreen_light,
        backgroundColor: bluegrey_dark,
      ),

    //Tabs
    bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS ?
    new CupertinoTabBar(
      activeColor: green_tab,
      currentIndex: _tab,
      onTap: onTap,
      items: TabItems.map((TabItem) {
        return new BottomNavigationBarItem(
          title: new Text(TabItem.title),
          icon: new Icon(TabItem.icon),
        );
      }).toList(),
    ):

    new BottomNavigationBar(
      currentIndex: _tab,
      onTap: onTap,
      fixedColor: green_tab,
      type: BottomNavigationBarType.fixed,
      items: TabItems.map((TabItem) {
        return new BottomNavigationBarItem(
          title: new Text(TabItem.title),
          icon: new Icon(TabItem.icon),
        );
      }).toList(),
    ), //

  );

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

}

class TabItem {
  const TabItem({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Announcements', icon: FontAwesomeIcons.slackHash,),
  const TabItem(title: 'Timer', icon: GroovinMaterialIcons.timer,),
  const TabItem(title: 'Events', icon: GroovinMaterialIcons.calendar_today,),
];