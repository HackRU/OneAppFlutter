import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:HackRU/colors.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {

  String _dataString = 'f@f.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('QR Code'),
          elevation: 0.0,
          leading: FlatButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: white, size: 30,),),
      ),
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
      color: bluegrey_dark,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: QrImage(
                  size: 250.0,
                  data: _dataString,
                  gapless: true,
                  foregroundColor: mintgreen_light,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}