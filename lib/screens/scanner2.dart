import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:path/path.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';


class QRScanner2 extends StatefulWidget {
  QRScanner2({Key key, this.title}) : super(key: key);
  final String title;
  final Map<String, dynamic> pluginParameters = {};

  @override
  _QRScanner2State createState() => new _QRScanner2State();
}

class _QRScanner2State extends State<QRScanner2> {
  Future<String> _barcodeString;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new FutureBuilder<String>(
              future: _barcodeString,
//              future: _qrcode,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return new Text(snapshot.data != null ? snapshot.data : '');
              }
          )
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: bluegrey_dark,
        onPressed: () {
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
          });
        },
        tooltip: 'QRCode Reader',
        child: new Icon(FontAwesomeIcons.camera, color: white,),
      ),
    );
  }
}

//Future<String> _qrcode = new QRCodeReader()
//    .setAutoFocusIntervalInMs(200)
//    .setForceAutoFocus(true)
//    .setTorchEnabled(true)
//    .setHandlePermissions(true)
//    .setExecuteAfterPermissionGranted(true)
//    .scan();