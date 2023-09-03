import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Cloud extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  List<Image> cloudImages;

  Cloud(this.screenHeight, this.screenWidth, this.cloudImages, {super.key});

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation cloudTranslation;

  late double x;
  late double y;
  late double size;
  late double speed;
  late double startX;
  late double endX;
  late Image cloudImage;

  void reset(AnimationController animationController) {
    setState(() {
      size = 200 - Random().nextDouble() * 100;
      speed = ((size - 200) / -100) * 50 + 30;

      animationController.duration =
          Duration(milliseconds: (1000 * speed).toInt());

      startX = -2000 + Random().nextDouble() * 1800;
      endX = widget.screenWidth + 200 - Random().nextDouble() * 100;
      x = startX;
      y = Random().nextDouble() * widget.screenHeight * 0.66 + 100;

      cloudImage =
          widget.cloudImages[Random().nextInt(widget.cloudImages.length - 1)];
      cloudTranslation =
          Tween<double>(begin: startX, end: endX).animate(animationController);
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
      if (cloudTranslation.value > widget.screenWidth + 100) {
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
      top: y,
      left: x,
      child: SizedBox(
        height: size,
        child: cloudImage,
      ),
    );
  }
}
