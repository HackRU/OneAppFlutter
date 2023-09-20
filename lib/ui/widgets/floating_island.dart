import 'package:flutter/material.dart';

class FloatingIsland extends StatefulWidget {
  // proportions with respect to screen size
  double top;
  double left;
  double floatDistance;

  // pixel values
  double size;

  double speed;
  int floatDuration;
  PageController? pageController;
  String imageName;

  FloatingIsland(
      {this.top = 0.1,
      this.left = 0.16,
      this.size = 100,
      this.floatDuration = 2000,
      this.floatDistance = 0.02,
      this.speed = 0.5,
      this.imageName = "",
      this.pageController,
      super.key});

  @override
  State<FloatingIsland> createState() => _FloatingIslandState();
}

class _FloatingIslandState extends State<FloatingIsland>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation floatingAnimation;

  // proportions with respect to screen size
  double dy = 0;
  double dx = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.floatDuration));
    floatingAnimation =
        Tween<double>(begin: 0, end: widget.floatDistance).animate(controller);

    if (widget.pageController != null) {
      widget.pageController!.addListener(() {
        setState(() => dx = -1 +
            widget.pageController!.page!.abs() * widget.speed +
            (1 - widget.speed));
      });
    }

    controller.addListener(() {
      setState(() => dy = floatingAnimation.value);
    });

    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: (widget.top + dy) * screenHeight,
      left: (widget.left + dx) * screenWidth,
      child: Container(
        // width: widget.size * screenWidth,
        width: widget.size * screenWidth,
        child: Image.asset(widget.imageName),
      ),
    );
  }
}
