import 'package:flutter/material.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: PinchZoomImage(
          image: Image.asset('assets/images/event_map.png'),
          zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
          hideStatusBarWhileZooming: false,
          onZoomStart: () {},
          onZoomEnd: () {},
        )
    );
  }
}

