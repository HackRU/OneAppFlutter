import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/exceptions.dart';
import 'package:hackru/models/models.dart';
import 'package:hackru/ui/pages/qr_scanner/QRScanner.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  var scanned = '';
  // late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  bool isPlaying = false;
  late MobileScannerController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     // controller.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     // controller.resumeCamera();
  //   } else if (kIsWeb) {
  //     cameraController.stop();
  //   }
  // }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
    _animationController?.dispose();
    cameraController.dispose();
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
              child: MobileScanner(
                allowDuplicates: false,
                onDetect: (barcode, args) {
                  final String code = barcode.rawValue!;
                  debugPrint('qr_code found: $code');
                  _qrRequest(code); // to call backend API
                },
              ),
            ),
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
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: HackRUColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    scanned,
                    style: const TextStyle(
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

//   void _onQRViewCreated(QRViewController controller) {
//     var defaultCode = 'xxx@xxx.com';
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print(
//           '======= SCANDATA: {code: ${scanData.code}, barcodeType: ${scanData.format.formatName}\n');
//       setState(() {
//         if (scanData.code != defaultCode) {
//           defaultCode = scanData.code!;
//           scanned = '';
//           // _qrRequest(scanData.code!);  // TODO: uncomment this later
//         } else {
// //          scanned = 'ALREADY SCANNED!';
//         }
//       });
//     });
//   }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController?.forward();
        // controller.pauseCamera();
        cameraController.stop();
      } else {
        _animationController?.reverse();
        // controller.resumeCamera();
        cameraController.start();
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
      await await _scanDialogWarning(message);
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
          title: const Icon(
            Icons.check_circle_outline,
            color: HackRUColors.off_white,
            size: 80.0,
          ),
          content: Text(body,
              style:
                  const TextStyle(fontSize: 25, color: HackRUColors.off_white),
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
          title: const Icon(
            Icons.warning,
            color: HackRUColors.off_white,
            size: 80.0,
          ),
          content: Text(body,
              style:
                  const TextStyle(fontSize: 25, color: HackRUColors.off_white),
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(15.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
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
