import 'dart:async';

import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/events/events_for_day.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(text: 'Saturday'),
        Tab(text: 'Sunday'),
      ],
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).accentColor,
      ),
      indicatorWeight: 2.0,
      indicatorSize: TabBarIndicatorSize.tab,
      controller: controller,
      unselectedLabelColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? HackRUColors.charcoal_light
              : HackRUColors.white,
      labelColor: HackRUColors.black,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      ),
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(children: tabs, controller: controller);
  }

  static List<Event>? cachedEvents;
  static DateTime cacheTTL = DateTime.now();

  Future<List<Event>> _getEvents() async {
    // if (cachedEvents != null) {
    //   streamctl.sink.add(cachedEvents!);
    // }
    // if (cacheTTL.isBefore(DateTime.now())) {
    //   print('cache miss');
    //   dayofEventsResources().then((events) {
    //     streamctl.sink.add(events);
    //     cachedEvents = events;
    //     cacheTTL = DateTime.now().add(Duration(minutes: 30));
    //   });
    // }
    var dayofEvents = List<Event>.empty();
    try {
      await dayofEventsResources().then((events) {
        dayofEvents = events;
      });
    } catch (e) {
      print('==== \nSlack data stream ctrl error: ' + e.toString());
    }
    return dayofEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: getTabBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Event>>(
        future: _getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
                // child: Container(
                //   color: HackRUColors.transparent,
                //   height: 400.0,
                //   width: 400.0,
                //   child: const RiveAnimation.asset(
                //     'assets/flare/loading_indicator.flr',
                //     alignment: Alignment.center,
                //     fit: BoxFit.contain,
                //     animations: ['idle'],
                //   ),
                // ),
              );
            default:
              print('==== hasSnapshotError: ${snapshot.hasError}');
              var events = snapshot.data;
              return getTabBarView(<Widget>[
                EventsForDay(day: '2', events: events),
                EventsForDay(day: '3', events: events),
              ]);
          }
        },
      ),
    );
  }
}
