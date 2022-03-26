// import 'package:hackru/styles.dart';
// import 'package:hackru/defaults.dart';
// import 'package:hackru/ui/widgets/loading_indicator.dart';
// import 'package:hackru/ui/widgets/transparent_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';

// class HackRUMap extends StatefulWidget {
//   @override
//   _HackRUMapState createState() => _HackRUMapState();
// }

// class _HackRUMapState extends State<HackRUMap> {
//   @override
//   Widget build(BuildContext context) {
//     var currentOrientation = MediaQuery.of(context).orientation;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: Container(
//         color: MediaQuery.of(context).platformBrightness == Brightness.light
//             ? white
//             : charcoal,
//         alignment: Alignment(0, 0),
//         child: PinchZoomImage(
//           image: currentOrientation == Orientation.portrait
//               ? Stack(
//                   children: <Widget>[
//                     Center(child: FancyLoadingIndicator()),
//                     Center(
//                       child: FadeInImage.memoryNetwork(
//                         placeholder: kTransparentImage,
//                         image: FLOOR_MAP_VER,
//                       ),
//                     ),
//                   ],
//                 )
//               : Stack(
//                   children: <Widget>[
//                     Center(child: FancyLoadingIndicator()),
//                     Center(
//                       child: FadeInImage.memoryNetwork(
//                         placeholder: kTransparentImage,
//                         image: FLOOR_MAP_HOR,
//                       ),
//                     ),
//                   ],
//                 ),
//           zoomedBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
//           hideStatusBarWhileZooming: false,
//         ),
//       ),
//     );
//   }
// }
