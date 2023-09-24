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
    Image.asset("assets/assets-png/cloud1.png",
        opacity: AlwaysStoppedAnimation(0.5)),
    Image.asset("assets/assets-png/cloud2.png",
        opacity: AlwaysStoppedAnimation(0.5)),
    Image.asset("assets/assets-png/cloud3.png",
        opacity: AlwaysStoppedAnimation(0.5)),
    Image.asset("assets/assets-png/cloud4.png",
        opacity: AlwaysStoppedAnimation(0.5)),
    Image.asset("assets/assets-png/cloud5.png",
        opacity: AlwaysStoppedAnimation(0.5)),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double widthToHeight = screenWidth / screenHeight;

    return Stack(children: [
      Cloud(
          cloudImage: cloudImages[1],
          top: 0.05,
          left: -1.75,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.8,
          speed: 0.03),
      Cloud(
          cloudImage: cloudImages[4],
          top: 0.375,
          left: -1,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.75,
          speed: 0.03),
      Cloud(
          cloudImage: cloudImages[3],
          top: 0.3,
          left: -2.25,
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          size: 0.5,
          speed: 0.03),
    ]);
  }
}
