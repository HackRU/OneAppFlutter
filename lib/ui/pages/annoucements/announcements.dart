import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/cache_service.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/utils/value_listenable2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'announcement_card.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key});

  @override
  State<StatefulWidget> createState() => AnnouncementsState();
}

class AnnouncementsState extends State {
  /// =================================================
  ///                GET SLACK MESSAGES
  /// =================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box<Announcement>('announcements').listenable(),
        builder: (context, __, _) {
          Box<Announcement> announcementsBox =
              Hive.box<Announcement>('announcements');

          List<Announcement> announcements = announcementsBox.values.toList();
          return LiquidPullToRefresh(
            color: Colors.transparent,
            backgroundColor: HackRUColors.pale_yellow,
            onRefresh: getSlacks,
            child: announcementsList(announcements),
          );
        },
      ),
    );
  }

  Widget announcementsList(List<Announcement> announcements) {
    return announcements.isEmpty
        ? const Center(child: Text("Nothing to see here..."))
        : Column(
            children: [
              const Text(kIsWeb
                  ? "Refresh Browser to update"
                  : "Swipe down to refresh"),
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 25.0),
                  controller: ScrollController(),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    return AnnouncementCard(
                      resource: announcements[index],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
