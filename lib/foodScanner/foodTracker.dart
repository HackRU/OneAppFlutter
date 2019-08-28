import 'dart:async';
import 'dart:io';
import 'package:HackRU/foodScanner/dashboard.dart';
import 'package:HackRU/foodScanner/foodScanner.dart';
import 'package:flutter/material.dart';
import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'package:HackRU/constants.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:HackRU/colors.dart';
import '../loading_indicator.dart';

var popup = true;
const NOT_SCANNED = "NOT SCANNED";

class FoodTracker extends StatefulWidget {
  static LcsCredential cred;
  static String event;

  FoodTracker({Key key}) : super(key: key);

  @override
  FoodTrackerState createState() => FoodTrackerState();

}

class FoodTrackerState extends State<FoodTracker> with TickerProviderStateMixin {
  Future<String> _message;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: pink,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/hackru_offwhite_logo.png', width: 200, height: 200,),
            Card(
              color: off_white,
              margin: EdgeInsets.all(10.0),
              child: Container(
                height: 100.0,
                child: InkWell(
                  splashColor: yellow,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
                  },
                  child: cardDetails('Dashboard', GroovinMaterialIcons.view_dashboard),
                ),
              ),
            ),
            Card(
              color: off_white,
              margin: EdgeInsets.all(10.0),
              child: Container(
                height: 100.0,
                child: InkWell(
                  splashColor: yellow,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FoodScanner()));
                  },
                  child: cardDetails('Food Scanner', GroovinMaterialIcons.qrcode_scan),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardDetails(text, icon){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(icon, color: pink, size: 35.0, semanticLabel: text+' icon',),
              SizedBox(height: 8.0,),
              new Text(
                text,
                style: TextStyle(color: pink, fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                semanticsLabel: text,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openQRScanner() async {
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
//      Navigator.pop(context);
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
        user = await getUser(DEV_URL, FoodTracker.cred, email);
        print("scanned user");
        print(user);
        if (!user.dayOf.containsKey(FoodTracker.event) ||
            user.dayOf[FoodTracker.event] == false) {
          print(user);
          result = "SCANNED!";

          if (FoodTracker.event == "checkInNoDelayed") {
            if (user.isDelayedEntry()
                && !await _scanDialogWarning("HACKER IS DELAYED ENTRY! SCAN ANYWAY?")) {
              return NOT_SCANNED;
            } else {
              FoodTracker.event = "checkIn";
            }
          }

          if (FoodTracker.event == "checkIn") {
            printLabel(email, MISC_URL);
          }

          updateUserDayOf(DEV_URL, FoodTracker.cred, user, FoodTracker.event);
        } else {
          result = 'ALREADY SCANNED!';
          if (FoodTracker.event == "checkIn") {
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
