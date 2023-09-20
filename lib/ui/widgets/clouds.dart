import 'dart:math';

import 'package:flutter/material.dart';

import 'cloud.dart';

class Clouds extends StatefulWidget {
  double screenHeight;
  Clouds(this.screenHeight, {super.key});

  @override
  State<Clouds> createState() => _CloudsState();
}

class _CloudsState extends State<Clouds> {
  int cloudFrequency = 5;

  List<Image> cloudImages = [
    Image.asset("assets/assets-png/cloud1.png"),
    Image.asset("assets/assets-png/cloud2.png"),
    Image.asset("assets/assets-png/cloud3.png"),
    Image.asset("assets/assets-png/cloud4.png"),
    Image.asset("assets/assets-png/cloud5.png"),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Cloud(
          cloudImage: cloudImages[1],
          top: 0.025,
          left: -1.75,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.25,
          speed: 0.01),
      Cloud(
          cloudImage: cloudImages[4],
          top: 0.1,
          left: -0.75,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.25,
          speed: 0.01),
      Cloud(
          cloudImage: cloudImages[1],
          top: 0.6,
          left: -1.25,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.25,
          speed: 0.01),
    ]);
  }
}
