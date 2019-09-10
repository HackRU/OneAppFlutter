import 'package:HackRU/colors.dart';
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
      color: off_white,
      child: PinchZoomImage(
        image: Image.asset('assets/images/map/event_map.png'),
        zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        hideStatusBarWhileZooming: false,
      ),
    );
  }
}


