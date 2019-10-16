import 'dart:async';
import 'dart:io';

import 'package:HackRU/colors.dart';
import 'package:HackRU/models/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/screens/scanner.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

import '../constants.dart';

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
                      color: card_color,
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
                        color: isPlaying ? yellow : card_color,
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
        // HANDLE CHECK_IN EVENT
        if (CardExpansion.event == "check-in") {
          if (_isEmailAddress(userEmailOrId)) {
            NewScanner.userEmail = userEmailOrId;
            user = await getUser(PROD_URL, QRScanner.cred, userEmailOrId);
            print('****** User: $user');
            result = "EMAIL SCANNED!";
          } else {
            if (NewScanner.userEmail != '') {
              linkQR(PROD_URL, QRScanner.cred, NewScanner.userEmail,
                  userEmailOrId);
              result = "DAY-OF QR LINKED!";
              print("**** Day-of QR linked!");
            } else {
              _scanDialogWarning('Scan Email First!');
            }
          }
        }

        // HANDLE CHECK_IN_DELAYED EVENT
        if (CardExpansion.event == "check-in-no-delayed") {
          if (_isEmailAddress(userEmailOrId)) {
            NewScanner.userEmail = userEmailOrId;
            user = await getUser(PROD_URL, QRScanner.cred, userEmailOrId);

            if (user.isDelayedEntry() &&
                !await _scanDialogWarning(
                    "HACKER IS DELAYED ENTRY! SCAN ANYWAY?")) {
              return NOT_SCANNED;
            } else {
              CardExpansion.event = "check-in";
            }

            result = "EMAIL SCANNED!";
            print('****** User: $user');
          } else {
            if (NewScanner.userEmail != '') {
              linkQR(PROD_URL, QRScanner.cred, NewScanner.userEmail,
                  userEmailOrId);
              result = "DAY-OF QR LINKED!";
              print("**** Day-of QR linked!");
            } else {
              _scanDialogWarning('Scan Email First!');
            }
          }
        }

        // HANDLE ALL THE OTHER EVENTS
        if (CardExpansion.event != "check-in" ||
            CardExpansion.event != "check-in-no-delayed") {
          numUserScanned = await attendEvent(
              PROD_URL, QRScanner.cred, userEmailOrId, CardExpansion.event);
          print("********** user event count: $numUserScanned");

          if (numUserScanned == 1) {
            result = "SCANNED!";
          } else {
            result = 'ALREADY SCANNED!';
            if (CardExpansion.event == "check-in") {
              if (await _scanDialogWarning("ALREADY SCANNED! RESCAN?")) {
                result = "SCANNED!";
              } else {
                return NOT_SCANNED;
              }
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
    final matcher = new RegExp(r"(.*?\@.*?)");
    return matcher.hasMatch(input);
  }
}
