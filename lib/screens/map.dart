import 'package:HackRU/colors.dart';
import 'package:HackRU/constants.dart';
import 'package:HackRU/models/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:transparent_image/transparent_image.dart';

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
            ? Stack(
                children: <Widget>[
                  Center(child: FancyLoadingIndicator()),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: FLOOR_MAP_VER,
                    ),
                  ),
                ],
              )
            : Stack(
                children: <Widget>[
                  Center(child: FancyLoadingIndicator()),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: FLOOR_MAP_HOR,
                    ),
                  ),
                ],
              ),
        zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        hideStatusBarWhileZooming: false,
      ),
    );
  }
}
