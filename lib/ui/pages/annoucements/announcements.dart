import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcement_card.dart';
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
    Box announcementsBox = Hive.box('cachedAnnouncements');

    try {
      slackResources().then((slackMsgs) {
        announcementsBox.put('announcements', slackMsgs);
      });
    } catch (e) {
      // TODO handle error
      debugPrint('Slack data stream ctrl error: ' + e.toString());
    }
  }

  /*
  Immediately load in cached announcments
  - For this we need to put this in a list
  Do the future to update cached announcements
  Then we display the new thing
  */
  @override
  Widget build(BuildContext context) {
    _getSlacks().then((_) => {}); // handle errors/cleanup in here if needed

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('announcements').listenable(),
          builder: (context, announcementBox, _) {
            List<Map<String, String>> announcementJsons =
                announcementBox.get('announcements');
            List<Announcement> announcements = announcementJsons
                .map((announcement) => Announcement.fromJson(announcement))
                .toList();
            // now depending on what's in these variables, generate a UI
            return Container();
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
