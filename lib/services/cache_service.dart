import 'dart:collection';

import 'package:hackru/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'hackru_service.dart';

Future<void> getSlacks() async {
  /*
    Just to update the Hive cache.
    */
  Box<Announcement> announcementsBox = Hive.box<Announcement>('announcements');
  Box loadingBox = Hive.box('loading');
  loadingBox.put('announcements', true);

  List<Announcement> pastAnnouncements = announcementsBox.values.toList();
  for (Announcement announcement in pastAnnouncements) {
    if (announcement.text!.startsWith("Error")) {
      announcementsBox.delete(announcement.hashCode);
    }
  }

  List<Map> announcementJsons = await slackResources();
  Map<int, Announcement> announcements = HashMap();

  for (var announcementJson in announcementJsons) {
    Announcement announcement =
        Announcement.fromJson(announcementJson as Map<String, dynamic>);

    announcements.putIfAbsent(announcement.hashCode, () => announcement);

    announcementsBox.put(announcement.hashCode, announcement);
  }

  List<Announcement> presentAnnouncements = announcementsBox.values.toList();

  for (Announcement inBoxAnnouncement in presentAnnouncements) {
    if (!announcements.containsKey(inBoxAnnouncement.hashCode)) {
      announcementsBox.delete(inBoxAnnouncement.hashCode);
    }
  }

  loadingBox.put('announcements', false);
}

Future<void> getEvents() async {
  // this exists to eliminate extraneous calls to LCS, waiting until the page
  // is fully in view before we try to get the data.

  // for more speed we could use a boolean that sets on the first call and
  // then blocks any calls after the initial one.

  Box<Event> eventsBox = Hive.box<Event>('events');
  Box loadingBox = Hive.box('loading');
  loadingBox.put('events', true);

  var dayofEvents = List<Event>.empty();
  try {
    await dayofEventsResources().then((events) {
      dayofEvents = events;
    });
  } catch (e) {
    print('==== \nSlack data stream ctrl error: ' + e.toString());
  }

  await eventsBox.clear();

  for (Event event in dayofEvents) {
    eventsBox.put(event.hashCode, event);
  }

  loadingBox.put('events', false);
}
