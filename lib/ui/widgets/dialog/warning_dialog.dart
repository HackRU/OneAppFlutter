import 'package:flutter/material.dart';
import 'package:hackru/styles.dart';

Future warningDialog(BuildContext context, String body, Color bgColor,
    Color textColor, Color splashColor) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context, {barrierDismissible = false}) {
      return AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Icon(
          Icons.warning,
          color: textColor,
          size: 80.0,
        ),
        content: Text(body,
            style: TextStyle(fontSize: 25, color: textColor),
            textAlign: TextAlign.center),
        actions: <Widget>[
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            splashColor: splashColor,
            height: 40.0,
            color: HackRUColors.off_white,
            onPressed: () async {
              Navigator.pop(context, true);
            },
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 20,
                color: bgColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    },
  );
}
