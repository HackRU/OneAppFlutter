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
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Container(
      color: white,
      alignment: Alignment(0, 0),
      child: PinchZoomImage(
        image: currentOrientation == Orientation.portrait
            ? Image.asset('assets/images/map/ver_hackru_casc_map.png')
            : Image.asset(
                'assets/images/map/horz_hackru_casc_map.png',
              ),
        zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        hideStatusBarWhileZooming: false,
      ),
    );
  }
}
