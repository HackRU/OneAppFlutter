import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/utils/value_listenable2.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Future<void> _getSlacks() async {
    /*
    Just to update the Hive cache.
    */
    Box<Announcement> announcementsBox =
        Hive.box<Announcement>('announcements');
    Box loadingBox = Hive.box('loading');
    loadingBox.put('announcements', true);

    List<Announcement> pastAnnouncements = announcementsBox.values.toList();
    for (Announcement announcement in pastAnnouncements) {
      if (announcement.text!.startsWith("Error")) {
        announcementsBox.delete(announcement.hashCode);
      }
    }

    try {
      slackResources().then((announcementJsons) {
        Map<int, Announcement> announcements = HashMap();

        for (var announcementJson in announcementJsons) {
          Announcement announcement =
              Announcement.fromJson(announcementJson as Map<String, dynamic>);

          announcements.putIfAbsent(announcement.hashCode, () => announcement);

          announcementsBox.put(announcement.hashCode, announcement);
        }

        List<Announcement> presentAnnouncements =
            announcementsBox.values.toList();

        for (Announcement inBoxAnnouncement in presentAnnouncements) {
          if (!announcements.containsKey(inBoxAnnouncement.hashCode)) {
            announcements.remove(inBoxAnnouncement.hashCode);
          }
        }
      });
    } catch (e) {
      // TODO handle error
      debugPrint('Slack data stream ctrl error: ' + e.toString());
    }

    loadingBox.put('announcements', false);
  }

  @override
  Widget build(BuildContext context) {
    _getSlacks().then((_) => {}); // handle errors/cleanup in here if needed

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
            child: ValueListenableBuilder2<Box, Box>(
              first: Hive.box<Announcement>('announcements').listenable(),
              second: Hive.box('loading').listenable(),
              builder: (context, ___, loadingBox, _) {
                Box<Announcement> announcementsBox =
                    Hive.box<Announcement>('announcements');
                List<Announcement> announcements =
                    announcementsBox.values.toList();

                return announcements.isEmpty
                    ? const Center(child: Text("Nothing to see here..."))
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 25.0,
                        ),
                        controller: ScrollController(),
                        itemCount: announcements.length,
                        itemBuilder: (context, index) {
                          return AnnouncementCard(
                            resource: announcements[index],
                          );
                        },
                      );
              },
            ),
            onRefresh: slackResources));

    // return Scaffold(
    //   backgroundColor: Colors.transparent,
    //   body: FutureBuilder<void>(
    //     future: ,
    //     builder: (
    //       BuildContext context,
    //       AsyncSnapshot<void> snapshot,
    //     ) {
    //       if (snapshot.hasError) {
    //         debugPrint('ERROR-->DASHBOARD: ${snapshot.hasError}');
    //       }

    //       debugPrint(resources.length.toString());
    //       return RefreshIndicator(
    //         color: Colors.white,
    //         backgroundColor: HackRUColors.pink,
    //         strokeWidth: 4,
    //         onRefresh: () async {
    //           var refreshedResources = await _getSlacks();
    //           if (mounted) {
    //             setState(() {
    //               resources = refreshedResources;
    //             });
    //           }
    //         },
    //         child: resources.isEmpty
    //             ? Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Column(
    //                       children: const [
    //                         Center(
    //                           child: Text(
    //                             "Fetching Announcements from Slack...",
    //                             style: TextStyle(
    //                                 color: HackRUColors.off_white_blue),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.all(20.0),
    //                           child: Center(
    //                             child: CircularProgressIndicator(),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             : ListView.builder(
    //                 physics: const AlwaysScrollableScrollPhysics(),
    //                 padding: const EdgeInsets.only(
    //                   bottom: 25.0,
    //                 ),
    //                 controller: ScrollController(),
    //                 itemCount: resources.length,
    //                 itemBuilder: (context, index) {
    //                   return AnnouncementCard(
    //                     resource: resources[index],
    //                   );
    //                 },
    //               ),
    //       );
    //     },
    //   ),
    // );
  }
}
