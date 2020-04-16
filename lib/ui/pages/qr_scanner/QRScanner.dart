import 'package:HackRU/styles.dart';
import 'package:HackRU/ui/pages/qr_scanner/newScanner.dart';
import 'package:HackRU/ui/widgets/custom_expansion_tile.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:HackRU/models/models.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:meta/meta.dart';

import '../../../defaults.dart';

const NOT_SCANNED = "NOT SCANNED";

class QRScanner extends StatefulWidget {
  static LcsCredential cred;
  static String userEmail, userPassword;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  var _isVisible;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
        future: qrEvents(MISC_URL),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Container(
                  color: transparent,
                  height: 400.0,
                  width: 400.0,
                  child: FlareActor(
                    'assets/flare/loading_indicator.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "idle",
                  ),
                ),
              );
            default:
              print(snapshot.hasError);
              return ListView(
                children: <Widget>[
                  CardExpansion(events: snapshot.data),
                ],
              );
          }
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: _isVisible == false
            ? null
            : new FloatingActionButton.extended(
                backgroundColor: yellow,
                splashColor: pink,
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewScanner(),
                    ),
                  );
                },
                tooltip: 'QRCode Reader',
                icon: Center(
                  child: Icon(
                    GroovinMaterialIcons.qrcode_scan,
                    color: charcoal_dark,
                    semanticLabel: 'QR Scanner Icon',
                  ),
                ),
                label: Text(
                  'Scan QR Codes',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: charcoal_dark,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

class CardExpansion extends StatefulWidget {
  CardExpansion({@required this.events});
  static const String routeName = '/material/expansion_panels';
  final List events;
  static String event;

  @override
  _CardExpansionState createState() => _CardExpansionState();
}

class _CardExpansionState extends State<CardExpansion> {
  bool isExpanded = false;
  var _isVisible;
  final GlobalKey<CustomExpansionTileState> expansionTileKey = new GlobalKey();
  var _selectedEvent = '--none--';

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
          child: Card(
            elevation: 0.0,
            color: (isExpanded == true) ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: CustomExpansionTile(
                key: expansionTileKey,
                onExpansionChanged: (bool expanding) =>
                    setState(() => this.isExpanded = expanding),
                trailing: Icon(
                  isExpanded
                      ? GroovinMaterialIcons.chevron_up
                      : GroovinMaterialIcons.chevron_down,
                  color: isExpanded ? grey : pink_dark,
                  size: 28.0,
                ),
                title: new Text(
                  this._selectedEvent,
                  style: new TextStyle(
                    color: isExpanded ? white : charcoal,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Text(
                  'Scanning: ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: isExpanded ? white : charcoal,
                  ),
                ),
                children: <Widget>[
                  new Container(
                    height: currentOrientation == Orientation.portrait
                        ? 300.0
                        : 120.0,
                    padding: EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: widget.events.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new ListTile(
                          title: Text(
                            widget.events[index],
                            style: new TextStyle(
                              color: isExpanded ? charcoal : Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () {
                            var selectedEvent = widget.events[index];
                            print('**** Selected Event: $selectedEvent\n');
                            setState(() {
                              this._selectedEvent = widget.events[index];
                              CardExpansion.event = this._selectedEvent;
                            });
                            expansionTileKey.currentState.collapse();
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
                height: currentOrientation == Orientation.portrait ? 300.0 : 0.0,
                child: FlareActor(
                  'assets/flare/forever_wondering.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "idle",
                ),
                ),
            ),
          )
          : Container(),
      ],
    );
  }
}
