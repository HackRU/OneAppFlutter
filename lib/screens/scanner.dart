import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:rubber/rubber.dart';
import 'package:HackRU/colors.dart';

import '../loading_indicator.dart';

var popup = true;
const NOT_SCANNED = "NOT SCANNED";

class QRScanner extends StatefulWidget {
  static LcsCredential cred;
  static String event;

  QRScanner({Key key}) : super(key: key);

  @override
  QRScannerState createState() => QRScannerState();

}

class QRScannerState extends State<QRScanner> with SingleTickerProviderStateMixin {

  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();
  Future<String> _message;
  var _selectedEvent = '* None *';
  var events = ['Check-In', 'Check-In No Delayed', 'Lunch1', 'Dinner', 'T-Shirt', 'Midnight Meal', 'Midnight Surprise', 'Breakfast', 'Lunch2'];

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.5),
        duration: Duration(milliseconds: 200)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RubberBottomSheet(
          scrollController: _scrollController,
          lowerLayer: _getLowerLayer(),
          header: new Container(
            height: 300.0,
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                color: pink,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                ),
              ),
              child: new Center(
                child: new Text("Select Event", style: TextStyle(fontSize: 20.0, color: off_white),),
              )),
          ),
          headerHeight: 60,
          upperLayer: _getUpperLayer(),
          animationController: _controller,
        ),
      ),
    );
  }

  openQRScanner() async {
    print("---------------scan button pressed ---------------------");
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context, {barrierDismissible: false}){
          return new AlertDialog(backgroundColor: Colors.transparent, elevation: 0.0,
            title: Center(
              child: new ColorLoader2(),
            ),
          );
        }
    );
    var _barcodeString = await new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .scan();
    print("processing _barcodeString");
    print(_barcodeString);
    // If the user didn't scan anything, then _barcodeString will be null.
    // If that is the case, then don't show a progress indicator popup or
    // do anything.
    popup = _barcodeString != null;
    if(popup) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context, {barrierDismissible: false}){
            return new AlertDialog(backgroundColor: Colors.transparent, elevation: 0.0,
              title: Center(
                child: new ColorLoader2(),
              ),
            );
          }
      );
      var message = await _lcsHandle(_barcodeString);
      // I'm (Sean) pretty sure that the scanner creates an extraneous
      // item on the Navigator stack. We need to pop it before we can pop
      // the loading indicator.
      Navigator.pop(context);
      // Now wew can pop the loading indicator.
      Navigator.pop(context);
      if (message != NOT_SCANNED) {
        _scanDialog(message);
      }
    } else {
      // I'm (Sean) pretty sure that the scanner creates an extraneous
      // item on the Navigator stack. We need to pop it before we continue.
      Navigator.pop(context);
      setState(() {
        _message = _lcsHandle(_barcodeString);
      });
    }
  }

  Widget _eventCard(index){
    return Card(
      color: off_white,
      margin: EdgeInsets.all(10.0),
      elevation: 0.0,
      child: Container(
        height: 60.0,
        child: InkWell(
          splashColor: yellow,
          onTap: () async {
            setState(() {
              _selectedEvent = events[index];
            });
            _controller.collapse();
            openQRScanner();
          },
          child: new Row (
            children: <Widget> [
              Expanded(
                child: new Text(events[index],
                  style: TextStyle(color: pink, fontSize: 20.0,),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLowerLayer() {
    return Container(
      decoration: BoxDecoration(
        color: off_white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selected Event:',
              style: TextStyle(fontSize: 20.0, color: pink,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.0,),
            Text('"$_selectedEvent"',
                style: TextStyle(fontSize: 25.0, color: pink, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      decoration: BoxDecoration(
        color: pink,
      ),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return _eventCard(index);
        },
      ),
    );
  }

  void _scanDialog(String body) async {
    switch(await showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}){
        return new AlertDialog(backgroundColor: white,
          title: Text(body, style: TextStyle(fontSize: 30, color: charcoal), textAlign:  TextAlign.center),
          actions: <Widget>[FlatButton(child: Text('OK', style: TextStyle(fontSize: 20, color: green), textAlign:  TextAlign.center), onPressed: (){Navigator.pop(context);},),],
        );
      },)){}
  }
  Future<bool> _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}){
        return new AlertDialog(backgroundColor: white,
          title: Text(body, style: TextStyle(fontSize: 30, color: charcoal), textAlign:  TextAlign.center),
          actions: <Widget>[
            FlatButton(child: Text('OK', style: TextStyle(fontSize: 20, color: green), textAlign:  TextAlign.center),
                onPressed: () async {
                  Navigator.pop(context, true);
                }),
            FlatButton(child: Text('CANCEL', style: TextStyle(fontSize: 20, color: pink), textAlign:  TextAlign.center),
                onPressed: (){
                  Navigator.pop(context, false);
                }),
          ],
        );
      },);
  }

  Future<String> _lcsHandle(String email) async {
    String result;
    print("called lcsHandle with qr:"+email);
    var user;
    try {
      if(email != null) {
        user = await getUser(DEV_URL, QRScanner.cred, email);
        print("scanned user");
        print(user);
        if (!user.dayOf.containsKey(QRScanner.event) ||
            user.dayOf[QRScanner.event] == false) {
          print(user);
          result = "SCANNED!";

          if (QRScanner.event == "checkInNoDelayed") {
            if (user.isDelayedEntry()
                && !await _scanDialogWarning("HACKER IS DELAYED ENTRY! SCAN ANYWAY?")) {
              return NOT_SCANNED;
            } else {
              QRScanner.event = "checkIn";
            }
          }

          if (QRScanner.event == "checkIn") {
            printLabel(email, MISC_URL);
          }

          updateUserDayOf(DEV_URL, QRScanner.cred, user, QRScanner.event);
        } else {
          result = 'ALREADY SCANNED!';
          if (QRScanner.event == "checkIn") {
            if (await _scanDialogWarning("ALREADY SCANNED! RESCAN?")) {
              printLabel(email, MISC_URL);
              result = "SCANNED!";
            } else {
              return NOT_SCANNED;
            }
          }
        }


      } else {
        print("attempt to scan null");
      }
    } on LcsLoginFailed {
      result = 'LCS LOGIN FAILED!';
    } on UpdateError {
      result = 'UPDATE ERROR';
    } on NoSuchUser {
      result = 'NO SUCH USER';
    } on LcsError {
      result = 'LCS ERROR';
    } on LabelPrintingError {
      result = "ERROR PRINTING LABEL";
    } on ArgumentError catch(e){
      result = 'UNEXPECTED ERROR';
      print(result);
      print(e);
      print(e.invalidValue);
      print(e.message);
      print(e.name);
    } on SocketException {
      result = "NETWORK ERROR";
    } catch(e) {
      result = 'UNEXPECTED ERROR';
      print(e);
    }
    return result;
  }
}
