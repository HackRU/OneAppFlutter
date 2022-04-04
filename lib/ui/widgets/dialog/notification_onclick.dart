import 'package:flutter/material.dart';

class NotificationOnClickDialog extends StatelessWidget {
  final String? title;
  final String? body;

  NotificationOnClickDialog({Key? key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 86,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            margin: EdgeInsets.only(top: 66),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              /*boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],*/
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '$body',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 66,
                child: Image.asset('assets/hackru-logos/hackru_white.png',
                    height: 100, width: 100)),
          )
        ],
      ),
    );
  }
}
