import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {

  String _dataString = 'https://www.hackru.org/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(),
      resizeToAvoidBottomPadding: true,
    );
  }

//  @override
//  void didUpdateWidget(QRCode oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    setState(() {});
//  }

  Widget _contentWidget() {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: QrImage(
                  data: _dataString,
                  gapless: false,
                  foregroundColor: const Color(0xFF111111),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}