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
    return Stack(
      children: getAnimatedClouds(context),
    );
  }

  List<Widget> getAnimatedClouds(BuildContext context) {
    List<Cloud> animatedClouds = [];
    for (int i = 0; i < cloudFrequency; i++) {
      animatedClouds.add(Cloud(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width, cloudImages));
    }

    return animatedClouds;
  }
}
