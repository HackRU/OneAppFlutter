import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HackRU/colors.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';


class SunEvents extends StatelessWidget {
  _event() {
    return <EventStruct>[
      EventStruct(
          eventTime:  '12:00 AM',
          eventTitle: 'Midnight Surprise',
          eventLocation:  "It's a surprise",
          map: Image.asset('assets/images/map/stageArea.png')),
      EventStruct(
          eventTime:  '02:00 AM',
          eventTitle: 'Midnight Snacks',
          eventLocation:  "Food Area",
          map: Image.asset('assets/images/map/foodArea.png')),
      EventStruct(
          eventTime:  '07:30 AM',
          eventTitle: 'Breakfast',
          eventLocation:  'Food Area',
          map: Image.asset('assets/images/map/foodArea.png')),
      EventStruct(
          eventTime:  '11:30 AM',
          eventTitle: 'Hacking Ends',
          eventLocation:  'Hacking Area',
          map: Image.asset('assets/images/map/hackingArea.png')),
      EventStruct(
          eventTime:  '11:30 AM',
          eventTitle: 'Lunch',
          eventLocation:  'Food Area',
          map: Image.asset('assets/images/map/foodArea.png')),
      EventStruct(
          eventTime:  '12:00 PM',
          eventTitle: 'Demos Begin',
          eventLocation:  'Hacking Area',
          map: Image.asset('assets/images/map/hackingArea.png')),
      EventStruct(
          eventTime:  '02:00 PM',
          eventTitle: 'Closing Ceremonies',
          eventLocation:  'Main Stage',
          map: Image.asset('assets/images/map/stageArea.png')),
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

  EventStruct({
    this.eventTitle, this.eventLocation, this.eventTime,this.map,
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
