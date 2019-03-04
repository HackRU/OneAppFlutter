import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/tabs/events_for_day.dart';
import 'package:HackRU/models.dart';
import 'package:HackRU/hackru_service.dart';
import 'dart:async';
import 'package:HackRU/loading_indicator.dart';

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
        indicatorColor: mintgreen_light,
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
      dayofEventsResources().then((events){
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
        backgroundColor: bluegrey_dark,
        appBar: new AppBar(
            title: getTabBar(),
            backgroundColor: bluegrey_dark,
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
                    EventsForDay(day: '09', events: events),
                    EventsForDay(day: '10', events: events)
                ]);
          }
        }
      )
    );
  }
}
