import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/pages/annoucements/announcement_card.dart';

class Announcements extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AnnouncementsState();
}

class AnnouncementsState extends State {
  /// =================================================
  ///                GET SLACK MESSAGES
  /// =================================================
  static List<Announcement>? cachedMsgs;

  Future<List<Announcement>> _getSlacks() async {
    var slackMessages = List<Announcement>.empty();
    try {
      await slackResources().then((slackMsgs) {
        slackMessages = slackMsgs;
      });
    } catch (e) {
      print('***********************\nSlack data stream ctrl error: ' +
          e.toString());
    }
    return slackMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<List<Announcement>?>(
        future: _getSlacks(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Announcement>?> snapshot) {
          if (snapshot.hasError) {
            debugPrint('ERROR-->DASHBOARD: ${snapshot.hasError}');
          }
          var resources = snapshot.data ?? [];
          debugPrint(resources.length.toString());
          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: HackRUColors.pink,
            strokeWidth: 4,
            onRefresh: () async {
              var refreshedResources = await _getSlacks();
              if (mounted) {
                setState(() {
                  resources = refreshedResources;
                });
              }
            },
            child: resources.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            Center(
                              child: Text(
                                "Fetching Announcements from Slack...",
                                style: TextStyle(
                                    color: HackRUColors.off_white_blue),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      bottom: 25.0,
                    ),
                    controller: ScrollController(),
                    itemCount: resources.length,
                    itemBuilder: (context, index) {
                      return AnnouncementCard(
                        resource: resources[index],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
