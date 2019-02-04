import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  String _dataString = 'Hello from this QR code!';
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(),
      resizeToAvoidBottomPadding: true,
    );
  }

  @override
  void didUpdateWidget(QRScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Widget _contentWidget() {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 30.0,
              right: 20.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Enter a custom message',
                        errorText: _inputErrorText,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      child: const Text('SUBMIT'),
                      onPressed: () {
                        setState(() {
                          _dataString = _textController.text;
                          _inputErrorText = null;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: QrImage(
                  data: _dataString,
                  gapless: false,
                  foregroundColor: const Color(0xFF111111),
                  onError: (dynamic ex) {
                    print('[QR] ERROR - $ex');
                    setState(() {
                      _inputErrorText =
                      'Error! Maybe your input value is too long?';
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:qrcode_reader/qrcode_reader.dart';
//
//class QRScanner extends StatefulWidget {
//  QRScanner({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  final Map<String, dynamic> pluginParameters = {
//  };
//
//  @override
//  _QRScannerState createState() => new _QRScannerState();
//}
//
//class _QRScannerState extends State<QRScanner> {
//  Future<String> _barcodeString;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: const Text('QRCode Reader Example'),
//      ),
//      body: new Center(
//          child: new FutureBuilder<String>(
//              future: _barcodeString,
//              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                return new Text(snapshot.data != null ? snapshot.data : '');
//              })),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: () {
//          setState(() {
//            _barcodeString = new QRCodeReader()
//                .setAutoFocusIntervalInMs(200)
//                .setForceAutoFocus(true)
//                .setTorchEnabled(true)
//                .setHandlePermissions(true)
//                .setExecuteAfterPermissionGranted(true)
//                .scan();
//          });
//        },
//        tooltip: 'Reader the QRCode',
//        child: new Icon(Icons.add_a_photo),
//      ),
//    );
//  }
//}