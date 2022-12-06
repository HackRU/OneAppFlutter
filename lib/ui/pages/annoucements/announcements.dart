import 'package:flutter/material.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/ui/hackru_app.dart';
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
    // var streamCtrl = StreamController<List<Announcement>>();
    // if (cachedMsgs != null) {
    //   streamCtrl.sink.add(cachedMsgs!);
    // }
    var slackMessages = List<Announcement>.empty();
    try {
      await slackResources().then((slackMsgs) {
        // debugPrint('======= slacks: $slackMsgs');
        slackMessages = slackMsgs;
      });
      // if (cacheTTL.isBefore(DateTime.now())) {
      //   slackResources().then((slackMsgs) {
      //     streamCtrl.sink.add(slackMsgs);
      //     persistSlackAnnouncements(slackMsgs);
      //     cacheTTL = DateTime.now().add(Duration(minutes: 5));
      //     streamCtrl.close();
      //   });
      // }
    } catch (e) {
      print('***********************\nSlack data stream ctrl error: ' +
          e.toString());
    }
    return slackMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Announcements:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        FutureBuilder<List<Announcement>?>(
          future: _getSlacks(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Announcement>?> snapshot) {
            if (snapshot.hasError) {
              debugPrint('ERROR-->DASHBOARD: ${snapshot.hasError}');
            }
            var resources = snapshot.data ?? [];
            debugPrint(resources.length.toString());
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: RefreshIndicator(
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
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            Center(
                              child:
                                  Text("Fetching Announcements from Slack..."),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 25.0,
                        ),
                        // itemCount: resources.length+1,
                        controller: ScrollController(),
                        itemCount: resources.length,
                        itemBuilder: (context, index) {
                          return AnnouncementCard(
                            resource: resources[index],
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
