import 'package:hackru/styles.dart';
import 'package:hackru/ui/widgets/custom_expansion_tile.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';

import '../../../defaults.dart';
import '../../../models/cred_manager.dart';
import 'newScanner.dart';

const NOT_SCANNED = 'NOT SCANNED';

const qrEvents = [
  "check-in",
  "check-in-no-delayed",
  "lunch-1",
  "dinner",
  "t-shirts",
  "midnight-meal",
  "midnight-surprise",
  "breakfast",
  "lunch-2",
  "raffle",
  "ctf-1",
  "ctf-2"
];

class QRScanner extends StatefulWidget {
  static LcsCredential? cred;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  var _isVisible;
  bool isAuthorized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  void _getUserProfile() async {
    var _storedEmail = await getEmail();
    if (_storedEmail != "") {
      var _authToken = await getAuthToken();
      var userProfile = await getUser(_authToken!, _storedEmail!);
      setState(() {
        isAuthorized =
            (userProfile.role.director || userProfile.role.organizer);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (isAuthorized
              ? ListView(
                  children: <Widget>[
                    CardExpansion(events: qrEvents),
                  ],
                )
              // ? FutureBuilder(
              //     future: qrEvents(MISC_URL),
              //     builder: (BuildContext context, AsyncSnapshot snapshot) {
              //       switch (snapshot.connectionState) {
              //         case ConnectionState.none:
              //         case ConnectionState.waiting:
              //           return const Center(
              //             child: CircularProgressIndicator(),
              //             // child: Container(
              //             //   color: HackRUColors.transparent,
              //             //   height: 400.0,
              //             //   width: 400.0,
              //             //   child: const RiveAnimation.asset(
              //             //     'assets/flare/loading_indicator.flr',
              //             //     alignment: Alignment.center,
              //             //     fit: BoxFit.contain,
              //             //     animations: ['idle'],
              //             //   ),
              //             // ),
              //           );
              //         default:
              //           print(snapshot.hasError);
              //           return ListView(
              //             children: <Widget>[
              //               CardExpansion(events: snapshot.data),
              //             ],
              //           );
              //       }
              //     },
              //   )
              : const Center(
                  child: Text(
                    "Sorry, you are not authorized to use this feature! Please login if you haven't!",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )),
      floatingActionButton: isAuthorized
          ? Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isVisible == false
                  ? null
                  : FloatingActionButton.extended(
                      backgroundColor: HackRUColors.yellow,
                      splashColor: HackRUColors.pink,
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scanner(),
                          ),
                        );
                      },
                      tooltip: 'QRCode Reader',
                      icon: const Center(
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: HackRUColors.charcoal_dark,
                          semanticLabel: 'QR Scanner Icon',
                        ),
                      ),
                      label: const Text(
                        'Scan QR Codes',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: HackRUColors.charcoal_dark,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

class CardExpansion extends StatefulWidget {
  CardExpansion({required this.events});
  static const String routeName = '/material/expansion_panels';
  final List events;
  static String? event;

  @override
  _CardExpansionState createState() => _CardExpansionState();
}

class _CardExpansionState extends State<CardExpansion> {
  bool isExpanded = false;
  final GlobalKey<CustomExpansionTileState> expansionTileKey = GlobalKey();
  var _selectedEvent = '--none--';

  @override
  Widget build(BuildContext context) {
    var currentOrientation = MediaQuery.of(context).orientation;

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
          child: Card(
            elevation: 0.0,
            color: (isExpanded == true)
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CustomExpansionTile(
                key: expansionTileKey,
                onExpansionChanged: (bool expanding) =>
                    setState(() => isExpanded = expanding),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color:
                      isExpanded ? HackRUColors.grey : HackRUColors.pink_dark,
                  size: 28.0,
                ),
                title: Text(
                  _selectedEvent.toUpperCase(),
                  style: TextStyle(
                    color:
                        isExpanded ? HackRUColors.white : HackRUColors.charcoal,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Text(
                  'Scanning: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color:
                        isExpanded ? HackRUColors.white : HackRUColors.charcoal,
                  ),
                ),
                children: <Widget>[
                  Container(
                    height: currentOrientation == Orientation.portrait
                        ? 300.0
                        : 120.0,
                    padding: EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: widget.events.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            widget.events[index].toString().toUpperCase(),
                            style: TextStyle(
                              color: isExpanded
                                  ? HackRUColors.charcoal
                                  : Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () {
                            var selectedEvent = widget.events[index];
                            print('**** Selected Event: $selectedEvent\n');
                            setState(() {
                              _selectedEvent = widget.events[index];
                              CardExpansion.event = _selectedEvent;
                            });
                            expansionTileKey.currentState?.collapse();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        !isExpanded
            ? Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Container(
                    height: currentOrientation == Orientation.portrait
                        ? 300.0
                        : 0.0,
                    child: const Text(
                        'Select event and above and scan for QR codes by clicking the button below'),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
