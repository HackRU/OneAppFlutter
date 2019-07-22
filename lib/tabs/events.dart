import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/tabs/events_for_day.dart';
import 'dart:async';
import 'package:HackRU/loading_indicator.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';

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

  TabBar getTabBar() {
    return new TabBar(
        tabs: <Tab>[
          new Tab(text: 'SATURDAY',),
          new Tab(text: 'SUNDAY',),],
        indicatorColor: yellow,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: controller
    );
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
        children: tabs, controller: controller);
  }

  static List<Event> cachedEvents = null;
  static DateTime cacheTTL = DateTime.now();
  Stream<List<Event>> _getEvents() {
    var streamctl = StreamController<List<Event>>();
    if (cachedEvents != null) {
      streamctl.sink.add(cachedEvents);
    }
    if (cacheTTL.isBefore(DateTime.now())) {
      print("cache miss");
      dayofEventsResources(PROD_URL).then((events){
          streamctl.sink.add(events);
          cachedEvents = events;
          cacheTTL = DateTime.now().add(Duration(minutes: 30));
      });
    }
    return streamctl.stream;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: charcoal,
        appBar: new AppBar(
            title: getTabBar(),
            backgroundColor: charcoal,
            elevation: 1.0,
            automaticallyImplyLeading: false,
        ),
        body: StreamBuilder<List<Event>>(
          stream: _getEvents(),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: new ColorLoader2(),
                );
                default:
                print(snapshot.hasError);
                var events = snapshot.data;
                return getTabBarView(<Widget>[
                    EventsForDay(day: '19', events: events),
                    EventsForDay(day: '20', events: events)
                ]);
          }
        }
      )
    );
  }
}
