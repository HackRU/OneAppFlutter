import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcement_card.dart';
import 'package:hackru/utils/value_listenable2.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Announcements extends StatefulWidget {
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

    try {
      slackResources().then((announcementJsons) {
        announcementJsons.forEach((announcementJson) {
          Announcement announcment =
              Announcement.fromJson(announcementJson as Map<String, dynamic>);
          announcementsBox.put(announcment.hashCode, announcment);
        });
      });
    } catch (e) {
      // TODO handle error
      debugPrint('Slack data stream ctrl error: ' + e.toString());
    }

    loadingBox.put('announcements', false);
  }

  Future<void> _getSlacksTest() async {
    Box<Announcement> announcementsBox =
        Hive.box<Announcement>('announcements');
    Box loadingBox = Hive.box('loading');
    loadingBox.put('announcements', true);

    Announcement announcement1 =
        Announcement(ts: "1571878519.113700", text: "Some text here");
    Announcement announcement2 =
        Announcement(ts: "1571878519.113700", text: "No text here");
    Announcement announcement3 =
        Announcement(ts: "1571888519.113700", text: "Some text here");

    try {
      announcementsBox.put(announcement1.hashCode, announcement1);
      announcementsBox.put(announcement1.hashCode, announcement1);
      announcementsBox.put(announcement2.hashCode, announcement2);
      announcementsBox.put(announcement3.hashCode, announcement3);
    } catch (e) {
      // TODO handle error
      debugPrint('Slack data stream ctrl error: ' + e.toString());
    }

    loadingBox.put('announcements', false);
  }

  /*
  Have some announcements in cache and loading
  have no announcemtns in cachte and loading
  have some announcements in cache and not loading
  have no announcements in cache and not loading
  */
  @override
  Widget build(BuildContext context) {
    _getSlacksTest().then((_) => {}); // handle errors/cleanup in here if needed

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ValueListenableBuilder2<Box, Box>(
          first: Hive.box<Announcement>('announcements').listenable(),
          second: Hive.box('loading').listenable(),
          builder: (context, ___, loadingBox, _) {
            Box<Announcement> announcementsBox =
                Hive.box<Announcement>('announcements');
            List<Announcement> announcements = announcementsBox.values.toList();

            // now depending on what's in these variables, generate a UI

            bool isLoading = loadingBox.get('announcements');
            Widget announcementsUI = isLoading
                ? const Center(child: Text("loading"))
                : announcements.isNotEmpty
                    ? const Center(child: Text("Has stuff"))
                    : const Center(child: Text("Has nothing"));

            return announcementsUI;
          },
        ));

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
