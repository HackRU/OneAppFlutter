//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:qrcode_reader/qrcode_reader.dart';
//import 'package:HackRU/colors.dart';
//
//class QRScanner extends StatefulWidget {
//  QRScanner({Key key, this.title}) : super(key: key);
//  final String title;
//  final Map<String, dynamic> pluginParameters = {};
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
//      body: new Center(
//          child: new FutureBuilder<String>(
//              future: _barcodeString,
//              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                return new Text(snapshot.data != null ? snapshot.data : '');
//              })),
//      floatingActionButton: new FloatingActionButton(
//        backgroundColor: bluegrey_dark,
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
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:HackRU/colors.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => new _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String qr;
  bool camState = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: bluegrey_dark,
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: camState
                    ? new Center(
                  child: new SizedBox(
                    width: 800.0,       //400
                    height: 1000.0,      //550
                    child: new QrCamera(
                      onError: (context, error) => Text(
                        error.toString(),
                        style: TextStyle(color: Colors.redAccent, fontSize: 5),
                      ),
                      qrCodeCallback: (code) {
                        setState(() {
                          qr = code;
                        });
                      },
                      child: new Container(
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: mintgreen_light, width: 2.0, style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ),
                )
                    : new Center(child: new Text("Camera Inactive!", style: TextStyle(fontSize: 25, color:  white),))
            ),
            new Text("QRCODE: $qr", style: TextStyle(color: white, fontSize: 15),),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: bluegrey,
          foregroundColor: mintgreen_light,
          child: new Icon(FontAwesomeIcons.camera),
          onPressed: () {
            showModalBottomSheet<Null>(
              context: context,
              builder: (BuildContext context) => _getDemoDrawer(),
            );
//            setState(() {
//              camState = !camState;
//            });
          }),
    );
  }

  Widget _getDemoDrawer() {
    return Drawer(
      child: ListView(
      children: <Widget>[
        SizedBox(height: 10,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.check_circle, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Check-In', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Lunch-1', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Dinner', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.tshirt_crew, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('T-Shirts', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Midnight-Meal', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.star, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Midnight-Surprise', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Breakfast', style: TextStyle(fontWeight: FontWeight.bold, color: mintgreen_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),
        Container(height: 60.0, color: bluegrey_dark, child: InkWell(splashColor: white, onTap: _open, child: new Row (children: <Widget> [Expanded(child: Row(children: <Widget>[Padding(padding: const EdgeInsets.all(8.0), child: new Icon(GroovinMaterialIcons.food_fork_drink, color: white,),), Padding(padding: const EdgeInsets.all(8.0), child: new Text('Lunch-2', style: TextStyle(fontWeight: FontWeight.bold, color: pink_light, fontSize: 25,),textAlign: TextAlign.center,),),],))]))), SizedBox(height: 5.0,),

      ],
      ),
    );
  }

  void _open() async {
    setState(() {
      camState = !camState;
    });
    Navigator.pop(context);
  }

}