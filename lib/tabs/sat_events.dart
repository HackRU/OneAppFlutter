import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class SatEvents extends StatelessWidget {
  _event() {
    return <EventStruct>[
      EventStruct(
          eventTime:  '10:00 AM',
          eventTitle: 'Check-In',
          eventLocation:  'Main Lobby',
          map: Image.asset('assets/images/map/registration.png'),
          color: bluegrey_dark),
      EventStruct(
          eventTime:  '11:00 AM',
          eventTitle: 'Lunch',
          eventLocation:  'Food Area',
          map: Image.asset('assets/images/map/foodArea.png'),
          color: bluegrey_dark),
      EventStruct(
          eventTime:  '11:30 AM',
          eventTitle: 'Opening Ceremonies',
          eventLocation:  'Main Stage',
          map: Image.asset('assets/images/map/stageArea.png'),
          color: bluegrey_dark),

    EventStruct(
          eventTime:  '01:00 PM',
          eventTitle: 'Hacking Commences',
          eventLocation:  'Hacking Area',
          map: Image.asset('assets/images/map/hackingArea.png'),
          color: pink_dark),
      EventStruct(
          eventTime:  '06:00 PM',
          eventTitle: 'Dinner',
          eventLocation:  'Food Area',
          map: Image.asset('assets/images/map/foodArea.png'),
          color: bluegrey_dark),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: EventList(_event()), backgroundColor: bluegrey_dark,);
  }
}

class EventStruct {
  final String eventTitle;
  final String eventLocation;
  final String eventTime;
  final Widget map;
  final Color color;

  EventStruct({
    this.eventTitle, this.eventLocation, this.eventTime, this.map, this.color,
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
            color: _eventStruct.color,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(16.0),
            child: PinchZoomImage(
              image: _eventStruct.map,
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
