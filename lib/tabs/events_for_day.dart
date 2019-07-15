import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';

class EventCard extends StatelessWidget {
  EventCard({@required this.resource, @required this.day});
  final Event resource;
  final String day;

  Widget build (BuildContext context){
    var time = resource.start.toLocal().toString().substring(11,16);
    var date = resource.start.toLocal().toString().substring(8,10);
    return Container(
      child: date == day ? new Card(
        child: ExpansionTile(
          leading: new Text(
            time,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: pink,
              textBaseline: TextBaseline.alphabetic,
              fontSize: 18.0,
            ),
          ),
          trailing: Icon(GroovinMaterialIcons.map_marker, color: yellow,),
          title: new Text(resource.summary,
            style: new TextStyle(
              color: green,
              fontSize: 20.0,
            ),
          ),
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(16.0),
              child: PinchZoomImage(
                image: Image.asset('assets/images/map/'+resource.location+'.png'),
                zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                hideStatusBarWhileZooming: false,
                onZoomStart: () {},
                onZoomEnd: () {},
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }
}

class EventsForDay extends StatelessWidget {
  final String day;
  final List<Event> events;
  EventsForDay({Key key, @required String this.day, @required this.events}): super(key: key);
  
  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: white,
      body: new Container(
        child: new ListView.builder(
          itemCount: events == null ? 0 : events.length,
          itemBuilder: (BuildContext context, int index) {
            return new EventCard(resource: events[index], day: this.day);
          }
        )
      )
    );
}
