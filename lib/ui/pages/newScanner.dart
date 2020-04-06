import 'dart:async';
import 'dart:io';

import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/exceptions.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/pages/scanner.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

var popup = true;
const NOT_SCANNED = "NOT SCANNED";

class NewScanner extends StatefulWidget {
  const NewScanner({Key key}) : super(key: key);
  static String userEmail;

  @override
  State<StatefulWidget> createState() => _NewScannerState();
}

class _NewScannerState extends State<NewScanner>
    with SingleTickerProviderStateMixin {
  var qrText = "";
  var scanned = "";
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController _animationController;
  bool isPlaying = false;
  Future<String> _message;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _message = Future<String>.sync(() => ' ');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.yellow,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            flex: 5,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    CardExpansion.event,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  new Text(
                    scanned,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: pink_light,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  new Container(
                    child: IconButton(
                      iconSize: 80,
                      icon: Icon(
                        isPlaying
                            ? GroovinMaterialIcons.play_circle
                            : GroovinMaterialIcons.pause_circle,
                        color: isPlaying ? yellow : pink_light,
                      ),
                      onPressed: () => _handleOnPressed(),
                    ),
                  ),
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var prevQR = 'xxx@xxx.com';
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print('-------------');
      print(scanData);
      setState(() {
        if (scanData != prevQR) {
          qrText = scanData;
          prevQR = scanData;
          scanned = "";
          _qrRequest(scanData);
        } else {
//          scanned = "ALREADY SCANNED!";
        }
      });
    });
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController.forward();
        controller?.pauseCamera();
      } else {
        _animationController.reverse();
        controller?.resumeCamera();
      }
    });
  }

  void _qrRequest(String scanData) async {
    print('************* qrRequest made ***********');
    var message;
    message = await _lcsHandle(scanData);
    if (message == "SCANNED!" ||
        message == "EMAIL SCANNED!" ||
        message == "DAY-OF QR LINKED!") {
      _scanDialogSuccess(message);
    } else {
      _scanDialogWarning(message);
    }
  }

  void _scanDialogSuccess(String body) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}) {
        return new AlertDialog(
          backgroundColor: pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Icon(
            Icons.check_circle_outline,
            color: off_white,
            size: 80.0,
          ),
          content: Text(body,
              style: TextStyle(fontSize: 25, color: off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: yellow,
              height: 40.0,
              color: off_white,
              onPressed: () {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 20, color: pink, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    )) {
    }
  }

  Future<bool> _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible: false}) {
        return new AlertDialog(
          backgroundColor: pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Icon(
            Icons.warning,
            color: off_white,
            size: 80.0,
          ),
          content: Text(body,
              style: TextStyle(fontSize: 25, color: off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL',
                  style: TextStyle(fontSize: 20, color: pink_dark),
                  textAlign: TextAlign.center),
              padding: const EdgeInsets.all(15.0),
              splashColor: off_white,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: yellow,
              height: 40.0,
              color: off_white,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 20, color: pink, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> _lcsHandle(String userEmailOrId) async {
    String result;
    print("***** Called `lcsHandle` with qr:" + userEmailOrId);
    var user;
    var numUserScanned;
    try {
      if (userEmailOrId != null) {
        String event = CardExpansion.event;
        // HANDLE CHECK_IN EVENT, potentially link
        if (event == "check-in" || event == "check-in-no-delayed") {
          if (_isEmailAddress(userEmailOrId)) {
            user = await getUser(BASE_URL, QRScanner.cred, userEmailOrId);
            if (event == "check-in-no-delayed") {
              if (user.isDelayedEntry()) {
                if (!await _scanDialogWarning(
                    "HACKER IS DELAYED ENTRY! SCAN ANYWAY?")) {
                  return NOT_SCANNED;
                }
              }
              event = "check-in";
            }
            NewScanner.userEmail = userEmailOrId;
          }

          print('****** User: $user');
          result = "EMAIL SCANNED!";
        }

        // ATTEND THE EVENT
        try {
          numUserScanned = await attendEvent(
              BASE_URL, QRScanner.cred, userEmailOrId, event, false);
          print("********** user event count: $numUserScanned");
          result = "SCANNED!";
        } on UserCheckedEvent {
          print("already " + userEmailOrId);
          if (await _scanDialogWarning("ALREADY SCANNED! RESCAN?")) {
            numUserScanned = await attendEvent(
                BASE_URL, QRScanner.cred, userEmailOrId, event, true);
            print("********** user event count: $numUserScanned");
            result = "SCANNED!";
          } else {
            return NOT_SCANNED;
          }
        } on UserNotFound catch (e) {
          print('h ' + userEmailOrId);
          if (!_isEmailAddress(userEmailOrId)) {
            if (NewScanner.userEmail != '') {
              linkQR(
                  BASE_URL, QRScanner.cred, NewScanner.userEmail, userEmailOrId);
              print("**** Day-of QR linked!");
              return "DAY-OF QR LINKED!";
            } else {
              _scanDialogWarning('Scan Email First!');
            }
          } else {
            throw e;
          }
        }
      } else {
        print("attempt to scan null");
      }
    } on LcsLoginFailed {
      result = 'LCS LOGIN FAILED!';
    } on UpdateError {
      result = 'UPDATE ERROR';
    } on PermissionError {
      result = 'UNAUTHORIZED USER/BAD ROLE';
    } on UserNotFound {
      result = 'NO SUCH USER';
    } on LcsError {
      result = 'LCS ERROR';
    } on LabelPrintingError {
      result = "ERROR PRINTING LABEL";
    } on ArgumentError catch (e) {
      result = 'UNEXPECTED ERROR';
      print(result);
      print(e);
      print(e.invalidValue);
      print(e.message);
      print(e.name);
    } on SocketException {
      result = "NETWORK ERROR";
    } catch (e) {
      result = 'UNEXPECTED ERROR';
      print(e);
    }
    return result;
  }

  bool _isEmailAddress(String input) {
    final matcher = new RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return matcher.hasMatch(input);
  }
}
