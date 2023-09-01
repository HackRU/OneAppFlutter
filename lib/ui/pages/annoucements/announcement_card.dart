import 'package:hackru/models/models.dart';
import 'package:hackru/models/string_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../styles.dart';

class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({required this.resource});
  final Announcement resource;

  @override
  Widget build(BuildContext context) {
    var secs = resource.ts?.split('.')[0];
    var timeStr =
        DateTime.fromMillisecondsSinceEpoch(int.parse(secs!) * 1000).toLocal();
    var formattedTime = DateFormat('hh:mm a').format(timeStr);

    return Container(
      key: Key(resource.ts!),
      child: Card(
        elevation: 0.0,
        color: resource.text!.startsWith('Error') ? Colors.red : Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              resource.text!.startsWith('Error')
                  ? Center(
                      child: Text(
                        resource.text!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: HackRUColors.blue_grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: StringParser(
                          text: resource.text ?? '',
                          linkStyle: const TextStyle(
                            color: HackRUColors.pink_light,
                            decoration: TextDecoration.underline,
                          ),
                          textStyle: const TextStyle(
                              fontSize: 15,
                              color: HackRUColors.pale_yellow,
                              fontFamily: "TitilliumWeb")),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
