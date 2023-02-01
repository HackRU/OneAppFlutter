import 'dart:async';
import 'dart:io';
import 'package:hackru/models/cred_manager.dart';
import 'package:hackru/styles.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/exceptions.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

var popup = true;
const notScanned = 'NOT SCANNED';

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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  bool isPlaying = false;
  MobileScannerController? cameraController;
  final TextEditingController _textFieldController = TextEditingController();
  CredManager? credManager;

  String _selectedEvent = "check-in";
  static const qrEvents = [
    "check-in",
    "delayed-check-in",
    "lunch-saturday",
    "dinner-saturday",
    "ws-react",
    "ws-cogsci_club",
    "ws-wics",
    "engg-lab-ctf",
    "mlh-cup-stacking",
    "breakfast-sunday",
    "lunch-sunday",
    "t-shirt",
    "swag",
    "extra-1",
    "extra-2"
  ];

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
    super.initState();
    cameraController = MobileScannerController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, size: 30),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
          title: Theme(
            data: ThemeData.dark(),
            child: DropdownButton(
              value: _selectedEvent,
              items: qrEvents
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedEvent = value as String),
            ),
          ),
        ),
        backgroundColor: HackRUColors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Center(
                child: MobileScanner(
                  allowDuplicates: false,
                  controller: cameraController,
                  onDetect: (barcode, args) {
                    final String code = barcode.rawValue!;
                    //debugPrint('qr_code found: $code');
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          iconSize: 80,
                          icon: Icon(
                            isPlaying
                                ? FontAwesomeIcons.circlePlay
                                : FontAwesomeIcons.circlePause,
                            color: isPlaying
                                ? HackRUColors.yellow
                                : HackRUColors.pink_light,
                          ),
                          onPressed: () => _handleOnPressed(),
                        ),
                        IconButton(
                          iconSize: 80,
                          icon: ValueListenableBuilder(
                            valueListenable:
                                cameraController!.cameraFacingState,
                            builder: (context, state, child) {
                              switch (state as CameraFacing) {
                                case CameraFacing.front:
                                  return const Icon(
                                    Icons.flip_camera_ios_outlined,
                                    color: HackRUColors.off_white,
                                    // size: 50,
                                  );
                                case CameraFacing.back:
                                  return const Icon(
                                    Icons.flip_camera_ios_rounded,
                                    color: HackRUColors.off_white,
                                    // size: 50,
                                  );
                              }
                            },
                          ),
                          onPressed: () => cameraController!.switchCamera(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _animationController?.forward();
        cameraController!.stop();
      } else {
        _animationController?.reverse();
        cameraController!.start();
      }
    });
  }

  void _qrRequest(String scanData) async {
    var message;
    message = await _lcsHandle(scanData);
    debugPrint(message);
    if (message == 'SCANNED!' ||
        message == 'EMAIL SCANNED!' ||
        message == 'DAY-OF QR LINKED!') {
      _scanDialogSuccess(message);
    } else {
      await await _warningDialog(message);
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

  Future _warningDialog(String body) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
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
            // TextButton(
            //   style: ButtonStyle(
            //     padding: MaterialStateProperty.all(
            //       const EdgeInsets.all(15.0),
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.pop(context, false);
            //   },
            //   child: const Text(
            //     'CANCEL',
            //     style: TextStyle(fontSize: 20, color: HackRUColors.pink_dark),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
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

  String? valueText;
  String? codeDialog;
  Future _displayTextInputDialog(BuildContext context) async {
    codeDialog = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: HackRUColors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text('Enter email to link'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration:
                  const InputDecoration(hintText: "emailtolink@email.com"),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(15.0),
                  ),
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(fontSize: 20, color: HackRUColors.pink_dark),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                splashColor: HackRUColors.yellow,
                height: 40.0,
                color: HackRUColors.off_white,
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
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<String> _lcsHandle(String userEmailOrId) async {
    // userEmailOrId is the scandata which comes from the qrcode
    var _storedEmail = credManager!.getEmail();
    var _authToken = credManager!.getAuthToken();
    var result = 'NULL';
    var user;
    var numUserScanned;
    try {
      if (userEmailOrId != '') {
        var event = _selectedEvent;
        /* ================= HANDLE CHECK_IN EVENT, potentially link ===============

        Logic 
        - if check-in
        -- don't let waitlist in. return notScanned
        -- else if not in waitlist,
        ---- change user.registrationStatus to checked-in
        ---- display message for checked in

        - if delayed-check-in, 
        -- change user.registrationStatus to checked-in
        -- display message for checked in
        
        */

        if (event == 'check-in') {
          if (_isEmailAddress(userEmailOrId)) {
            user = await getUser(_authToken, _storedEmail, userEmailOrId);
            if (user.isDelayedEntry()) {
              return "EMAIL ON WAITLIST, NOT SCANNED.";
            } else {
              if (user.registrationStatus == 'registered') {
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'confirmation');
                debugPrint('moved to confirmation');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'coming');
                debugPrint('moved to coming');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'confirmed');
                debugPrint('moved to confirmed');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'checked-in');
                debugPrint('moved to checked-in');
              }
              if (user.registrationStatus == 'confirmation') {
                debugPrint("confirmation");
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'coming');
                debugPrint('moved to coming');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'confirmed');
                debugPrint('moved to confirmed');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'checked-in');
                debugPrint('moved to checked-in');
              }
              if (user.registrationStatus == 'not-coming') {
                debugPrint("not-coming");
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'coming');
                debugPrint('moved to coming');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'confirmed');
                debugPrint('moved to confirmed');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'checked-in');
                debugPrint('moved to checked-in');
              }
              if (user.registrationStatus == 'coming') {
                debugPrint("coming");
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'confirmed');
                debugPrint('moved to confirmed');
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'checked-in');
                debugPrint('moved to checked-in');
              }
              if (user.registrationStatus == 'confirmed') {
                await updateStatus(BASE_URL, _storedEmail, _authToken,
                    userEmailOrId, 'checked-in');
                debugPrint('moved to checked-in');
              }
              if (user.registrationStatus == 'checked-in') {
                result = "SCANNED";
              }
              // result = "EMAIL SCANNED";
            }
          }
        } else if (event == 'delayed-check-in') {
          if (_isEmailAddress(userEmailOrId)) {
            user = await getUser(_authToken, _storedEmail, userEmailOrId);
            if (user.registrationStatus == 'registered') {
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'confirmation');
              debugPrint('moved to confirmation');
              await updateStatus(
                  BASE_URL, _storedEmail, _authToken, userEmailOrId, 'coming');
              debugPrint('moved to coming');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'confirmed');
              debugPrint('moved to confirmed');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'confirmation') {
              debugPrint("confirmation");
              await updateStatus(
                  BASE_URL, _storedEmail, _authToken, userEmailOrId, 'coming');
              debugPrint('moved to coming');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'confirmed');
              debugPrint('moved to confirmed');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'not-coming') {
              debugPrint("not-coming");
              await updateStatus(
                  BASE_URL, _storedEmail, _authToken, userEmailOrId, 'coming');
              debugPrint('moved to coming');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'confirmed');
              debugPrint('moved to confirmed');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'coming') {
              debugPrint("coming");
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'confirmed');
              debugPrint('moved to confirmed');
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'confirmed') {
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'waitlist') {
              await updateStatus(BASE_URL, _storedEmail, _authToken,
                  userEmailOrId, 'checked-in');
              debugPrint('moved to checked-in');
            }
            if (user.registrationStatus == 'checked-in') {
              result = "SCANNED";
            }
            // result = "EMAIL SCANNED";
          }
        }

        // ATTEND THE EVENT
        try {
          // debugPrint('${Scanner.userEmail}');
          numUserScanned = await attendEvent(
            BASE_URL,
            _storedEmail,
            _authToken,
            userEmailOrId,
            event,
            false,
          );
          // updateStatus(
          //     BASE_URL, _storedEmail, _authToken, userEmailOrId, "checked-in");
          // debugPrint('********** user event count: $numUserScanned');
          result = 'SCANNED!';
        } on UserCheckedEvent {
          // var prev = numUserScanned;
          // debugPrint('already ' + userEmailOrId);
          result = 'ALREADY SCANNED';
          var rescan = await _warningDialog('ALREADY SCANNED!');
          // if (rescan) {
          //   return notScanned;
          // }
          // // debugPrint('$rescan');
          if (rescan) {
            numUserScanned = await attendEvent(
              BASE_URL,
              _storedEmail,
              _authToken,
              userEmailOrId,
              event,
              true,
            );
            // int test = numUserScanned as int;
            // debugPrint('********** user event count: $test');
            // if (prev > numUserScanned) {
            result = 'SCANNED!';
            // }
          } else {
            return notScanned;
          }
        } on UserNotFound {
          // debugPrint('hashqr:' + userEmailOrId);
          if (!_isEmailAddress(userEmailOrId)) {
            codeDialog = '';
            await _displayTextInputDialog(context);
            var linkToUser = codeDialog;
            // debugPrint('linkToUser: $linkToUser');
            if (!_isEmailAddress(linkToUser!) ||
                linkToUser == null ||
                linkToUser == '') {
              debugPrint('Not an email: $linkToUser');
              return 'NOT A VALID EMAIL';
            } else {
              debugPrint('Email to link: $linkToUser');
              try {
                linkQR(
                  BASE_URL,
                  _storedEmail,
                  _authToken,
                  linkToUser,
                  userEmailOrId,
                );
                return 'DAY-OF QR LINKED!';
              } on UserNotFound {
                return 'USER NOT FOUND';
              }
            }
          } else {
            rethrow;
          }
        }
      } else {
        // print('attempt to scan null');
        result = 'NULL ERROR';
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
      debugPrint('======================');
      print(result);
      print(e);
      print(e.invalidValue);
      print(e.message);
      print(e.name);
      print(e.stackTrace);
      debugPrint('======================');
    } on SocketException {
      result = 'NETWORK ERROR';
    } catch (e) {
      result = 'UNEXPECTED ERROR';
      debugPrint('===== TRY CATCH =====');
      print(result);
      print(e);
      debugPrint('======= TRY CATCH ======');
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
