import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hackru/services/cache_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/events/events_for_day.dart';
import 'package:flutter/material.dart';
import 'package:hackru/utils/value_listenable2.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Events extends StatefulWidget {
  PageController _pageController;

  Events(this._pageController);

  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Event>("events").listenable(),
        builder: (BuildContext context, __, _) {
          Box<Event> eventsBox = Hive.box<Event>("events");

          return LiquidPullToRefresh(
              color: Colors.transparent,
              backgroundColor: HackRUColors.pale_yellow,
              onRefresh: getEvents,
              child: eventsList(eventsBox.values.toList()));
        },
      ),
    );
  }

  Widget eventsList(List<Event> events) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const Text(
              kIsWeb ? "Refresh Browser to update" : "Swipe down to refresh"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                titleCard(
                    "Saturday", Colors.transparent, HackRUColors.pale_yellow),
                ...getEventsForDay('Saturday', events),
                titleCard(
                    "Sunday", Colors.transparent, HackRUColors.pale_yellow),
                ...getEventsForDay('Sunday', events),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card titleCard(String title, Color bgColor, Color textColor) {
    return Card(
      color: bgColor,
      elevation: 0,
      child: Text(title, style: TextStyle(fontSize: 30, color: textColor)),
    );
  }

  List<Widget> getEventsForDay(String day, List<Event> events) {
    events.sort((Event a, Event b) => a.start!.compareTo(b.start!));

    List<EventCard> eventWidgets = events
        .where(
            (event) => DateFormat("EEEE").format(event.start!.toLocal()) == day)
        .toList()
        .map((event) => EventCard(
            day: day,
            resource: event,
            titleColor: HackRUColors.pale_yellow,
            bgColor: Colors.black26,
            tsColor: Colors.white))
        .toList();

    if (eventWidgets.isEmpty) {
      return [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          color: Colors.black26,
          child: const ListTile(
            title: Text(
              "No Events",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                textBaseline: TextBaseline.alphabetic,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ];
    }

    return eventWidgets;
  }
}
