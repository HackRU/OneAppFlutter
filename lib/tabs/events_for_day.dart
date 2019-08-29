import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/models/expandable_image.dart';

class EventCard extends StatelessWidget {
  EventCard({@required this.resource, @required this.day});
  final Event resource;
  final String day;

  Widget build (BuildContext context) {
    var time = resource.start.toLocal().toString().substring(11, 16);
    var date = resource.start.toLocal().toString().substring(8, 10);
    var today = DateTime.now().day.toString();
    if (date == day || date == today) {
      return Container(
        child: new Card(
          color: off_white,
          child: ExpansionTile(
            leading: new Text(
              time,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: charcoal_light,
                textBaseline: TextBaseline.alphabetic,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Icon(
              GroovinMaterialIcons.map_marker, color: grey, size: 28.0,),
            title: new Text(resource.summary,
              style: new TextStyle(
                color: pink,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(12.0),
                child: ExpandableImage(
                  Image.asset('assets/images/map/' + resource.location + '.png'),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(height: 0.0,);
  }
}

class EventsForDay extends StatelessWidget {
  final String day;
  final List<Event> events;
  EventsForDay({Key key, @required this.day, @required this.events}): super(key: key);
  
  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: pink,
      body: new Container(
        child: new ListView.builder(
          itemCount: events == null ? 1 : events.length,
          itemBuilder: (BuildContext context, int index) {
            return new EventCard(resource: events[index], day: this.day);
          }
        )
      )
    );
}
