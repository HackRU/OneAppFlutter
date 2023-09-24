import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Cloud extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  Image cloudImage;

  double top;
  double left;

  double size;
  double speed;

  Cloud({
    required this.screenHeight,
    required this.screenWidth,
    required this.cloudImage,
    required this.top,
    required this.left,
    required this.size,
    required this.speed,
    super.key,
  });

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation cloudTranslation;

  late double x;

  void reset(AnimationController animationController) {
    setState(() {
      int durationms = 100000;
      double totalDistanceToTravel =
          widget.speed * durationms / 1000 * widget.screenWidth;
      x = widget.left * widget.screenWidth;
      double end =
          widget.screenWidth + (totalDistanceToTravel - widget.screenWidth + x);

      if ((totalDistanceToTravel - widget.screenWidth + x) < 0) {
        durationms += 1000 *
            (totalDistanceToTravel - widget.screenWidth + x).abs() ~/
            (widget.speed * widget.screenWidth);

        end = widget.screenWidth;
      }

      animationController.duration = Duration(milliseconds: durationms);

      cloudTranslation =
          Tween<double>(begin: x, end: end).animate(animationController);
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animationController.addListener(() {
      if (cloudTranslation.value > widget.screenWidth) {
        animationController.reset();
        reset(animationController);
        return;
      }

      setState(() => x = cloudTranslation.value);
    });

    reset(animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top * widget.screenHeight,
      left: x,
      child: SizedBox(
        // height: widget.size * widget.screenHeight,
        width: widget.size * widget.screenWidth,
        child: widget.cloudImage,
      ),
    );
  }
}
