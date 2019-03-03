import 'package:flutter/material.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class EventCard extends StatelessWidget {
  EventCard({@required this.resource});
  final Event resource;

  Widget build (BuildContext context){
    return new Card(
      child: ExpansionTile(
        leading: new Text(
          resource.start.toIso8601String(),
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: green_tab,
            fontWeight: FontWeight.w800,
            textBaseline: TextBaseline.alphabetic,
            fontSize: 18.0,
          ),
        ),
        trailing: Icon(GroovinMaterialIcons.map_marker, color: bluegrey,),
        title: new Text(resource.summary,
          style: new TextStyle(
            color: bluegrey_dark,
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(16.0),
            child: PinchZoomImage(
              image: Image.asset('assets/images/map/registration.png'),
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

class SatEvents2 extends StatelessWidget {
  @override
  Widget build (BuildContext context) => new Scaffold(
      backgroundColor: bluegrey_dark,
      body: new FutureBuilder<List<Event>>(
          future: dayofEventsResources(),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(mintgreen_light), strokeWidth: 3.0,),
                );
              default:
                print(snapshot.hasError);
                var resources = snapshot.data;
                print(resources);
                return new Container(
                    child: new ListView.builder(
                        itemCount: resources == null ? 0 : resources.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new EventCard(resource: resources[index]);
                        }
                    )
                );
            }
          }
      )
  );
}
