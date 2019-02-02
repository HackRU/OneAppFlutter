import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class SatEvents extends StatelessWidget {
  _event() {
    return <EventStruct>[
      const EventStruct(
          eventTime:  '10:00 AM',
          eventTitle: 'Registration Opens',
          eventInfo:  'Be on time!'),
      const EventStruct(
          eventTime:  '11:00 AM',
          eventTitle: 'Lunch',
          eventInfo:  'Variety of foods before hackinG!'),
      const EventStruct(
          eventTime:  '11:30 AM',
          eventTitle: 'Opening Ceremony',
          eventInfo:  'Sponsors will announce special prices!'),
      const EventStruct(
          eventTime:  '01:00 PM',
          eventTitle: 'Hacking Commences',
          eventInfo:  'Here you go!'),
      const EventStruct(
          eventTime:  '06:00 PM',
          eventTitle: 'Dinner',
          eventInfo:  'Yeah! Its a moment you have been waiting for!'),
      const EventStruct(
          eventTime:  '10:00 PM',
          eventTitle: 'Coffee',
          eventInfo:  'Break time!'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: EventList(_event()), backgroundColor: bluegrey_dark,);
  }
}

class EventStruct {
  final String eventTitle;
  final String eventInfo;
  final String eventTime;

  const EventStruct({
    this.eventTitle, this.eventInfo, this.eventTime
  });
}

class EventListItem extends StatelessWidget{
  final EventStruct _eventStruct;
  EventListItem(this._eventStruct);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: ExpansionTile(
        leading: new Text(
          _eventStruct.eventTime,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: green_tab,
            fontWeight: FontWeight.w800,
            textBaseline: TextBaseline.alphabetic,
            fontSize: 18.0,
          ),
        ),
        trailing: Icon(GroovinMaterialIcons.map_marker, color: bluegrey,),
        title: new Text(_eventStruct.eventTitle,
          style: new TextStyle(
            color: bluegrey,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(16.0),
            child: PinchZoomImage(
              image: Image.asset('assets/images/event_map.png'),
              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
              hideStatusBarWhileZooming: false,
              onZoomStart: () {},
              onZoomEnd: () {},
            ),
          )
        ],
      ),
    );
  }
}

class EventList extends StatelessWidget{
  final List<EventStruct> _eventStruct;
  EventList(this._eventStruct);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: new EdgeInsets.symmetric(vertical: 7.0),
      children: _buildEventList(),
    );
  }

  List<EventListItem> _buildEventList() {
    return _eventStruct.map((event) => new EventListItem(event))
        .toList();
  }
}
