import 'dart:async';
import 'dart:io';

import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/styles.dart';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/exceptions.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/ui/pages/qr_scanner/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

var popup = true;
const NOT_SCANNED = 'NOT SCANNED';

class Scanner extends StatefulWidget {
  const Scanner({
    Key? key,
  }) : super(key: key);
  static String? userEmail;

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  var qrText = '';
  var scanned = '';
  //QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HackRUColors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
                child: /*QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.yellow,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),*/
                    Text('Temporarily Removed QR Scanner')),
          ),
          Flexible(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    CardExpansion.event!,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: HackRUColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    scanned,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: HackRUColors.pink_light,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      iconSize: 80,
                      icon: Icon(
                        isPlaying
                            ? FontAwesomeIcons.playCircle
                            : FontAwesomeIcons.pauseCircle,
                        color: isPlaying
                            ? HackRUColors.yellow
                            : HackRUColors.pink_light,
                      ),
                      onPressed: () => _handleOnPressed(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /*void _onQRViewCreated(QRViewController controller) {
    var prevQR = 'xxx@xxx.com';
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print('-------------');
      print(scanData);
      setState(() {
        if (scanData != prevQR) {
          qrText = scanData;
          prevQR = scanData;
          scanned = '';
          _qrRequest(scanData);
        } else {
//          scanned = 'ALREADY SCANNED!';
        }
      });
    });
  }*/

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController?.forward();
        //controller?.pauseCamera();
      } else {
        _animationController?.reverse();
        //controller?.resumeCamera();
      }
    });
  }

  void _qrRequest(String scanData) async {
    print('************* qrRequest made ***********');
    var message;
    message = await _lcsHandle(scanData);
    if (message == 'SCANNED!' ||
        message == 'EMAIL SCANNED!' ||
        message == 'DAY-OF QR LINKED!') {
      _scanDialogSuccess(message);
    } else {
      await _scanDialogWarning(message);
    }
  }

  void _scanDialogSuccess(String body) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible = false}) {
        return AlertDialog(
          backgroundColor: HackRUColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Icon(
            Icons.check_circle_outline,
            color: HackRUColors.off_white,
            size: 80.0,
          ),
          content: Text(body,
              style: TextStyle(fontSize: 25, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: HackRUColors.yellow,
              height: 40.0,
              color: HackRUColors.off_white,
              onPressed: () {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 20,
                    color: HackRUColors.pink,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    )) {
    }
  }

  Future<Future> _scanDialogWarning(String body) async {
    return showDialog(
      context: context,
      builder: (BuildContext context, {barrierDismissible = false}) {
        return AlertDialog(
          backgroundColor: HackRUColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Icon(
            Icons.warning,
            color: HackRUColors.off_white,
            size: 80.0,
          ),
          content: Text(body,
              style: TextStyle(fontSize: 25, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.all(15.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'CANCEL',
                style: TextStyle(fontSize: 20, color: HackRUColors.pink_dark),
                textAlign: TextAlign.center,
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              splashColor: HackRUColors.yellow,
              height: 40.0,
              color: HackRUColors.off_white,
              onPressed: () async {
                Navigator.pop(context, true);
              },
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20,
                  color: HackRUColors.pink,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String> _lcsHandle(String userEmailOrId) async {
    var _storedEmail = await getEmail();
    var _authToken = await getAuthToken();
    var result;
    print('***** Called `lcsHandle` with qr:' + userEmailOrId);
    var user;
    var numUserScanned;
    try {
      if (userEmailOrId != null) {
        var event = CardExpansion.event;
        // HANDLE CHECK_IN EVENT, potentially link
        if (event == 'check-in' || event == 'check-in-no-delayed') {
          if (_isEmailAddress(userEmailOrId)) {
            user = await getUser(_authToken!, _storedEmail!, userEmailOrId);
            if (event == 'check-in-no-delayed') {
              if (user.isDelayedEntry()) {
                return NOT_SCANNED;
                // *** TODO: FIX THIS LOGIC
                // if (_scanDialogWarning(
                //     'HACKER IS DELAYED ENTRY! SCAN ANYWAY?')) {
                //   return NOT_SCANNED;
                // }
              }
              event = 'check-in';
            }
            Scanner.userEmail = userEmailOrId;
          }

          print('****** User: $user');
          result = 'EMAIL SCANNED!';
        }

        // ATTEND THE EVENT
        try {
          numUserScanned = await attendEvent(
            BASE_URL,
            QRScanner.cred!,
            userEmailOrId,
            event!,
            false,
          );
          print('********** user event count: $numUserScanned');
          result = 'SCANNED!';
        } on UserCheckedEvent {
          print('already ' + userEmailOrId);
          //** TODO: FIX THIS LOGIC AS WELL */
          // if (await _scanDialogWarning('ALREADY SCANNED! RESCAN?')) {
          //   numUserScanned = await attendEvent(
          //       BASE_URL, QRScanner.cred, userEmailOrId, event, true);
          //   print('********** user event count: $numUserScanned');
          //   result = 'SCANNED!';
          // }
          // else {
          //   return NOT_SCANNED;
          // }
        } on UserNotFound {
          print('h ' + userEmailOrId);
          if (!_isEmailAddress(userEmailOrId)) {
            if (Scanner.userEmail != '') {
              linkQR(
                BASE_URL,
                QRScanner.cred!,
                Scanner.userEmail!,
                userEmailOrId,
              );
              print('**** Day-of QR linked!');
              return 'DAY-OF QR LINKED!';
            } else {
              // *** TODO: also fix this, looks weird
              await await _scanDialogWarning('Scan Email First!');
            }
          } else {
            rethrow;
          }
        }
      } else {
        print('attempt to scan null');
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
      result = 'ERROR PRINTING LABEL';
    } on ArgumentError catch (e) {
      result = 'UNEXPECTED ERROR';
      print(result);
      print(e);
      print(e.invalidValue);
      print(e.message);
      print(e.name);
    } on SocketException {
      result = 'NETWORK ERROR';
    } catch (e) {
      result = 'UNEXPECTED ERROR';
      print(e);
    }
    return result;
  }

  bool _isEmailAddress(String input) {
    final matcher = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return matcher.hasMatch(input);
  }
}
