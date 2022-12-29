import 'package:flutter/material.dart';

import '../../styles.dart';

class DashboardButton extends StatelessWidget {
  DashboardButton(
      {required this.onPressed, required this.color, required this.label});
  VoidCallback onPressed;
  Color color;
  String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: color,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: HackRUColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
