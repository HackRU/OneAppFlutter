import 'dart:async';

import 'package:hackru/styles.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/events/events_for_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> with SingleTickerProviderStateMixin {
  Future<List<Event>> _getEvents() async {
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
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<Event>>(
        future: _getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              print('==== hasSnapshotError: ${snapshot.hasError}');
              var events = snapshot.data;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(children: <Widget>[
                  titleCard("Saturday"),
                  ...getEventsForDay('Sunday', events!),
                  titleCard("Sunday"),
                  ...getEventsForDay('Monday', events),
                ]),
              );
          }
        },
      ),
    );
  }

  Card titleCard(String title) {
    return Card(
      elevation: 0,
      child: Text(title, style: TextStyle(fontSize: 30)),
    );
  }

  List<EventCard> getEventsForDay(String day, List<Event> events) {
    return events
        .where((event) => DateFormat("EEEE").format(event.start!) == day)
        .toList()
        .map((event) => EventCard(
              day: day,
              resource: event,
            ))
        .toList();
  }
}
