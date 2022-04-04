import 'package:hackru/styles.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatefulWidget {
  PageNotFound({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PageNotFoundState createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HackRUColors.off_white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              height: 400.0,
              child: Text(
                '404! \n Page not found!',
                style: TextStyle(
                    fontSize: 25.0,
                    color: HackRUColors.pink,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50.0, bottom: 35.0),
            height: 400.0,
            child: const Text('Oops, page not found!'),
            // child: const RiveAnimation.asset(
            //   'flare/Filip.flr',
            //   alignment: Alignment.center,
            //   fit: BoxFit.contain,
            //   animations: ['idle'],
            // ),
          ),
        ],
      ),
    );
  }
}
