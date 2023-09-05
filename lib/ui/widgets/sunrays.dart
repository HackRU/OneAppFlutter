import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Sunrays extends StatefulWidget {
  const Sunrays({super.key});

  @override
  State<Sunrays> createState() => _SunraysState();
}

class _SunraysState extends State<Sunrays> with SingleTickerProviderStateMixin {
  late Animation<double> rotate;
  late AnimationController animationController;

  double currentAngle = 0;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    rotate = Tween<double>(begin: 0, end: 0.05).animate(animationController);

    animationController.repeat(reverse: true);

    animationController
        .addListener(() => setState(() => currentAngle = rotate.value));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -100,
      left: 0,
      child: CustomPaint(
        painter: SunEffectPainter(
            MediaQuery.of(context).size.height * 3 / 4, currentAngle),
      ),
    );
  }
}

class SunEffectPainter extends CustomPainter {
  double screenWidth;
  double angle;

  bool shouldPaint = false;

  SunEffectPainter(
    this.screenWidth,
    this.angle,
  );

  @override
  void paint(Canvas canvas, Size size) {
    shouldPaint = false;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = screenWidth;

    Paint frontRays = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withOpacity(0.1 + angle),
          Colors.white.withOpacity(0),
        ],
      );

    Paint backRays = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withOpacity(0.05 + angle),
          Colors.white.withOpacity(0),
        ],
      );

    // TODO remove shado between circles
    canvas.drawPath(
        Path()
          ..moveTo(center.dx, center.dy)
          ..addArc(
              Rect.fromCircle(center: center, radius: radius / 2.5), 0, 2 * pi),
        Paint()
          ..shader = ui.Gradient.radial(center, radius / 2.5, [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.09),
          ]));

    canvas.drawPath(
        Path()
          ..moveTo(center.dx, center.dy)
          ..addArc(
              Rect.fromCircle(center: center, radius: radius / 3.5), 0, 2 * pi),
        Paint()
          ..shader = ui.Gradient.radial(center, radius / 3.5, [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.08),
          ]));

    int numRays = 3;

    double arc = pi / 4 / numRays;

    double emptySpaceSum = pi / 8;
    double raySpaceSum = 0;

    for (int i = 0; i < numRays; i++) {
      double emptySapce = arc - angle;
      double raySpace = arc + angle;

      canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy)
            ..arcTo(
                Rect.fromCircle(
                  center: center,
                  radius: radius,
                ),
                emptySpaceSum + raySpaceSum - angle,
                raySpace + angle / 2,
                false)
            ..close(),
          frontRays);

      emptySpaceSum += emptySapce;
      raySpaceSum += raySpace;
    }
    arc = pi / 4 / numRays;
    emptySpaceSum = pi / 8;
    raySpaceSum = 0;
    for (int i = 0; i < numRays; i++) {
      double emptySapce = arc - angle;
      double raySpace = arc + angle;

      canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy)
            ..arcTo(
                Rect.fromCircle(
                  center: center,
                  radius: radius,
                ),
                emptySpaceSum + raySpaceSum - pi * 0.02 - angle,
                raySpace + pi * 0.04 + angle / 2,
                false)
            ..close(),
          backRays);

      emptySpaceSum += emptySapce;
      raySpaceSum += raySpace;
    }
    shouldPaint = true;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return shouldPaint;
  }
}
