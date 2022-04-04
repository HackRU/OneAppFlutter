import 'package:flutter/material.dart';

import '../../../styles.dart';

class ErrorDialog extends StatelessWidget {
  final String? body;

  const ErrorDialog({Key? key, this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Icon(
        Icons.warning,
        color: HackRUColors.pink,
        size: 80.0,
      ),
      content: Text(
        body!,
        style: TextStyle(
          fontSize: 18,
          color: HackRUColors.pink,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          splashColor: HackRUColors.white,
          height: 40.0,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pop(context, true);
          },
          padding: const EdgeInsets.all(14.0),
          child: const Text(
            'OK',
            style: TextStyle(
                fontSize: 16,
                color: HackRUColors.white,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
