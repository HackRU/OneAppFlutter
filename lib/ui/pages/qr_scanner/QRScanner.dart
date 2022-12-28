import 'package:hackru/styles.dart';
import 'package:hackru/ui/widgets/custom_expansion_tile.dart';
import 'package:hackru/services/hackru_service.dart';
import 'package:hackru/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../defaults.dart';
import '../../../models/cred_manager.dart';
import 'newScanner.dart';

const NOT_SCANNED = 'NOT SCANNED';

const qrEvents = [
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

class QRScanner extends StatefulWidget {
  static LcsCredential? cred;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  var _isVisible;
  CredManager? credManager;

  @override
  void initState() {
    credManager = Provider.of<CredManager>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, size: 30),
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
          )),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: (credManager!.getAuthorization()
          ? ListView(
              controller: ScrollController(),
              children: <Widget>[
                CardExpansion(events: qrEvents),
              ],
            )
          : const Center(
              child: Text(
                "Sorry, you are not authorized to use this feature! Please login if you haven't!",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )),
      floatingActionButton: credManager!.getAuthorization()
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
                            builder: (context) => Provider.value(
                                value: credManager, child: Scanner()),
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
  static String? event = 'check-in';

  @override
  _CardExpansionState createState() => _CardExpansionState();
}

class _CardExpansionState extends State<CardExpansion> {
  bool isExpanded = false;
  final GlobalKey<CustomExpansionTileState> expansionTileKey = GlobalKey();
  var _selectedEvent = 'check-in';

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
                  _selectedEvent,
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
                            widget.events[index],
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
