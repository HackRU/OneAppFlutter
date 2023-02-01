import 'package:flutter/material.dart';

import '../../styles.dart';

class DashboardButton extends StatelessWidget {
  DashboardButton(
      {required this.onPressed,
      required this.bgColor,
      required this.textColor,
      required this.label});
  VoidCallback onPressed;
  Color bgColor;
  Color textColor;
  String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
