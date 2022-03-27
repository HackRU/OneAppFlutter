import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

const helpResources = [
  {"name": "MentorQ", "desc": "mentorship", "url": "http://mentorq.hackru.org"},
  {
    "name": "Slack",
    "desc": "talk to friends at hackru",
    "url": "http://tinyurl.com/hackru-f19"
  },
  {
    "name": "Devpost",
    "desc": "submit your projects",
    "url": "https://hackru-s22.devpost.com/"
  },
  {
    "name": "Food Menu",
    "desc": "breakfast, lunch, and dinner",
    "url": "https://s3-us-west-2.amazonaws.com/hackru-misc/menu.pdf"
  }
];

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        itemCount: helpResources.length,
        itemBuilder: (BuildContext context, int index) {
          HelpResource helpResource =
              HelpResource.fromJson(helpResources[index]);
          return HelpButton(
            resource: helpResource,
          );
        },
      ),
//       body: FutureBuilder<List<HelpResource>>(
//         future: helpResources(MISC_URL),
//         builder:
//             (BuildContext context, AsyncSnapshot<List<HelpResource>> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//               return const Center(
//                 child: CircularProgressIndicator(),
//                 // child: Container(
//                 //   color: HackRUColors.transparent,
//                 //   height: 400.0,
//                 //   width: 400.0,
//                 //   child: const RiveAnimation.asset(
//                 //     'assets/flare/loading_indicator.flr',
//                 //     alignment: Alignment.center,
//                 //     fit: BoxFit.contain,
//                 //     animations: ['idle'],
//                 //   ),
//                 // ),
//               );
//             default:
//               print(snapshot.hasError);
//               var resources = snapshot.data;
// //              print(resources);
//               return !snapshot.hasError
//                   ? ListView.builder(
//                       itemCount: resources?.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return HelpButton(resource: resources![index]);
//                       },
//                     )
//                   : const Center(
//                       child: Text(
//                         'An error occurred while fetching help resources!',
//                       ),
//                     );
//           }
//         },
//       ),
    );
  }
}

class HelpButton extends StatelessWidget {
  HelpButton({required this.resource});
  final HelpResource resource;

  void _open() async {
    if (await canLaunch(resource.url)) {
      await launch(resource.url);
    } else {
      print('failed to launch url');
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 0.0,
        child: Container(
          height: 100.0,
          child: InkWell(
            splashColor: HackRUColors.yellow,
            onTap: _open,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        resource.name.toUpperCase(),
                        style: TextStyle(
                          color: HackRUColors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          resource.description,
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
