import 'package:HackRU/colors.dart';
import 'package:flutter/material.dart';
import 'package:HackRU/models/expandable_image.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: off_white,
      child: ExpandableImage(Image.asset('assets/images/map/event_map.png')),
    );
  }
}


