import 'package:hackru/styles.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  EventCard({required this.resource, required this.day});
  final Event resource;
  final String day;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var _brightnessValue = MediaQuery.of(context).platformBrightness;
    var time = DateFormat('hh:mm a').format(widget.resource.start!.toLocal());
    var date = DateFormat.d().format(widget.resource.start!.toLocal());
    var today = DateTime.now().toString();
    print(DateFormat("MMMd").format(widget.resource.start!));
    if (DateFormat("EEEE").format(widget.resource.start!) == widget.day) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        color: (isExpanded)
            ? Theme.of(context).primaryColor
            : Theme.of(context).dividerColor,
        child: ExpansionTile(
          onExpansionChanged: (bool expanding) =>
              setState(() => isExpanded = expanding),
          leading: Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isExpanded
                  ? (_brightnessValue == Brightness.light
                      ? Colors.yellow.shade500
                      : HackRUColors.charcoal_dark)
                  : Theme.of(context).primaryColor,
              textBaseline: TextBaseline.alphabetic,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: isExpanded
                ? HackRUColors.white
                : (_brightnessValue == Brightness.light
                    ? HackRUColors.charcoal_light
                    : HackRUColors.white),
            size: 35.0,
          ),
          title: Text(
            widget.resource.summary ?? '',
            style: TextStyle(
              color: isExpanded
                  ? HackRUColors.white
                  : (_brightnessValue == Brightness.light
                      ? HackRUColors.charcoal_light
                      : HackRUColors.white),
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                bottom: 15.0,
              ),
              child: Image.asset(widget.resource.location == null
                  ? 'assets/map/appIconImageWhite.png'
                  : 'assets/map/' + widget.resource.location! + '.png'),
              // child: PinchZoomImage(
              //   image: Image.asset(
              //       'assets/map/' + widget.resource.location + '.png'),
              //   zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
              //   hideStatusBarWhileZooming: false,
              // ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
