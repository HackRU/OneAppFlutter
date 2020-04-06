import 'package:HackRU/styles.dart';
import 'package:HackRU/models/models.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

class EventCard extends StatefulWidget {
  EventCard({@required this.resource, @required this.day});
  final Event resource;
  final String day;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isExpanded = false;

  Widget build(BuildContext context) {
    var time =
        new DateFormat('hh:mm a').format(widget.resource.start.toLocal());
    var date = new DateFormat.d().format(widget.resource.start.toLocal());
    var today = DateTime.now().day.toString();
    if (date == widget.day || date == today) {
      return Container(
        child: new Card(
          elevation: 0.0,
          color: (isExpanded == true) ? off_white : pink_light,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: ExpansionTile(
              onExpansionChanged: (bool expanding) =>
                  setState(() => this.isExpanded = expanding),
              leading: new Text(
                time,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: isExpanded ? charcoal_light : off_white,
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: Icon(
                GroovinMaterialIcons.map_marker,
                color: isExpanded ? grey : pink_dark,
                size: 28.0,
              ),
              title: new Text(
                widget.resource.summary,
                style: new TextStyle(
                  color: isExpanded ? pink : off_white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(12.0),
                  child: PinchZoomImage(
                    image: Image.asset('assets/map/' +
                        widget.resource.location +
                        '.png'),
                    zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
                    hideStatusBarWhileZooming: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 0.0,
    );
  }
}

class EventsForDay extends StatelessWidget {
  final String day;
  final List<Event> events;
  EventsForDay({Key key, @required this.day, @required this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) => new Scaffold(
        backgroundColor: pink,
        body: new Container(
          child: new ListView.builder(
            itemCount: events == null ? 1 : events.length,
            itemBuilder: (BuildContext context, int index) {
              return new EventCard(resource: events[index], day: this.day);
            },
          ),
        ),
      );
}
