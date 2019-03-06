import 'package:HackRU/colors.dart';
import 'package:HackRU/filestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {

  String userEmailAddr;

  @override
  void initState() {
    super.initState();
    getStoredCredential().then((cred) {
      if (cred != null) {
        userEmailAddr = cred.email.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluegrey_dark,
      appBar: AppBar(
        title: Title(color: white, child: Text('Qr Code')),
      ),
      body: _contentWidget(),
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget _contentWidget() {
    print("******************");
    print(userEmailAddr);

    return Container(
      height: 250.0,
      width: 250.0,
      color: white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: QrImage(
                  data: userEmailAddr,
                  gapless: true,
                  foregroundColor: bluegrey,
                  onError: (dynamic ex){
                    print('[QR] ERROR - $ex');
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