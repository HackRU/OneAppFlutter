import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:HackRU/colors.dart';
import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';

//Future<String> _qrcode = new QRCodeReader()
//    .setAutoFocusIntervalInMs(200)
//    .setForceAutoFocus(true)
//    .setTorchEnabled(true)
//    .setHandlePermissions(true)
//    .setExecuteAfterPermissionGranted(true)
//    .scan();

@visibleForTesting
enum Location {
  CheckIn, Lunch1, Dinner, TShirts, MidnightMeal, MidnightSurprise, Breakfast, Lunch2
}

typedef DemoItemBodyBuilder<T> = Widget Function(DemoItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({
    this.name,
    this.value,
    this.hint,
    this.showHint
  });

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: textTheme.body1.copyWith(fontSize: 16.0, color: bluegrey_dark, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                  margin: const EdgeInsets.only(left: 24.0),
                  child: _crossFade(
                      Text(value, style: textTheme.caption.copyWith(fontSize: 15.0)),
                      Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
                      showHint
                  )
              )
          )
        ]
    );
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody({
    this.margin = EdgeInsets.zero,
    this.child,
    this.onSave,
    this.onCancel
  });

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0
              ) - margin,
              child: Center(
                  child: DefaultTextStyle(
                      style: textTheme.caption.copyWith(fontSize: 15.0),
                      child: child
                  )
              )
          ),
          const Divider(height: 1.0),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: FlatButton(
                            onPressed: onCancel,
                            child: const Text('CANCEL', style: TextStyle(color: bluegrey, fontSize: 15.0, fontWeight: FontWeight.w500))
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: FlatButton(
                            onPressed: onSave,
                            child: const Text('SAVE', style: TextStyle(color: pink_dark, fontSize: 15, fontWeight: FontWeight.w500),)
                        )
                    )
                  ]
              )
          )
        ]
    );
  }
}

class DemoItem<T> {
  DemoItem({
    this.name,
    this.value,
    this.hint,
    this.builder,
    this.valueToString
  }) : textController = TextEditingController(text: valueToString(value));

  final String name;
  final String hint;
  final TextEditingController textController;
  final DemoItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
          name: name,
          value: valueToString(value),
          hint: hint,
          showHint: isExpanded
      );
    };
  }

  Widget build() => builder(this);
}

class QRScanner2 extends StatefulWidget {
  QRScanner2({Key key, this.title}) : super(key: key);
  static const String routeName = '/material/expansion_panels';
  final String title;
  final Map<String, dynamic> pluginParameters = {};

  @override
  _QRScanner2State createState() => _QRScanner2State();
}

class _QRScanner2State extends State<QRScanner2> {
  List<DemoItem<dynamic>> _demoItems;
  Future<String> _barcodeString;
  var _eventSelected;

  @override
  void initState() {
    super.initState();

    _demoItems = <DemoItem<dynamic>>[
      DemoItem<Location>(name: 'Scanning...', value: Location.CheckIn, hint: 'Select Event',
          valueToString: (Location location) => location.toString().split('.')[1],
          builder: (DemoItem<Location> item) {
            void close() { setState(() { item.isExpanded = false;});}
            return Form(
                child: Builder(
                    builder: (BuildContext context) {
                      return CollapsibleBody(
                        onSave: () { Form.of(context).save(); close(); },
                        onCancel: () { Form.of(context).reset(); close(); },
                        child: FormField<Location>(
                            initialValue: item.value,
                            onSaved: (Location result) { item.value = result; },
                            builder: (FormFieldState<Location> field) {
                              return Column(
                                  mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RadioListTile<Location>(value: Location.CheckIn, title: const Text('Check-In'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.Lunch1, title: const Text('Lunch-1'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.Dinner, title: const Text('Dinner'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.TShirts, title: const Text('T-Shirts'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.MidnightMeal, title: const Text('Midnight-Meal'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.MidnightSurprise, title: const Text('Midnight-Surprise'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.Breakfast, title: const Text('Breakfast'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                    RadioListTile<Location>(value: Location.Lunch2, title: const Text('Lunch-2'), groupValue: field.value, onChanged: field.didChange, activeColor: pink_dark,),
                                  ]
                              );
                            }
                        ),
                      );
                    }
                ),
            );
          }
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluegrey_dark,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SafeArea( top: false, bottom: false,
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                  child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() { _demoItems[index].isExpanded = !isExpanded; });},
                      children: _demoItems.map<ExpansionPanel>((DemoItem<dynamic> item) {
                        return ExpansionPanel( isExpanded: item.isExpanded, headerBuilder: item.headerBuilder, body: item.build());}).toList()
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.0),
                child: new FutureBuilder<String>(
                    future: _barcodeString,
                    // future: _qrcode,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: mintgreen_light, width: 2.0, style: BorderStyle.solid),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(snapshot.data != null ? snapshot.data : 'Note: Click [Camera Icon] Below to Scan QR Codes!',
                              style: TextStyle(color: mintgreen_light, fontSize: 20.0,), textAlign: TextAlign.center,),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: bluegrey,
        onPressed: () {
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();
          });
        },
        tooltip: 'QRCode Reader',
        icon: Icon(FontAwesomeIcons.camera, color: mintgreen_light,),
        label: Text('Scan', style: TextStyle(fontSize: 15.0, color: mintgreen_light),),
      ),
    );
  }
}