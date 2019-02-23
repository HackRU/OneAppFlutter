import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/tabs/sat_events.dart';
import 'package:HackRU/tabs/sun_events.dart';

class Events extends StatefulWidget{
  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events>
    with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var saturday = new Text('Saturday',
    textAlign: TextAlign.center,
    style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),);
  var sunday = new Text('Sunday',
    textAlign: TextAlign.center,
    style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),);

  TabBar getTabBar() {
    return new TabBar(
        tabs: <Tab>[
          new Tab(text: 'SATURDAY',),
          new Tab(text: 'SUNDAY'),],
        indicatorColor: mintgreen_light,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: controller
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
        children: tabs, controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: getTabBar(),
            backgroundColor: bluegrey_dark,
            elevation: 1.5,
            automaticallyImplyLeading: false,
        ),
        body: getTabBarView(<Widget>[
          new SatEvents(), new SunEvents()])
    );
  }
}
