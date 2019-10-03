import 'package:HackRU/colors.dart';
import 'package:HackRU/models/models.dart';
import 'package:HackRU/screens/newScanner.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const NOT_SCANNED = "NOT SCANNED";

@visibleForTesting
enum Event {
  Check_In,
  Lunch_1,
  Dinner,
  T_Shirt,
  Midnight_Meal,
  Midnight_Surprise,
  Breakfast,
  Lunch_2,
  Check_In_No_Delayed,
}

typedef DemoItemBodyBuilder<T> = Widget Function(DemoItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.value, this.hint, this.showHint});

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
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: textTheme.body1.copyWith(
                  fontSize: 16.0, color: charcoal, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
      Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  Text(value,
                      style: textTheme.caption.copyWith(fontSize: 15.0)),
                  Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
                  showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody(
      {this.margin = EdgeInsets.zero, this.child, this.onSave, this.onCancel});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(children: <Widget>[
      Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) -
              margin,
          child: Center(
              child: DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
    ]);
  }
}

class DemoItem<T> {
  DemoItem({this.name, this.value, this.hint, this.builder, this.valueToString})
      : textController = TextEditingController(text: valueToString(value));

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
          showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

class QRScanner2 extends StatefulWidget {
  QRScanner2({Key key, this.title}) : super(key: key);
  static const String routeName = '/material/expansion_panels';
  final String title;
  final Map<String, dynamic> pluginParameters = {};
  static String userEmail, userPassword;
  static LcsCredential cred;
  static String event;

  @override
  _QRScanner2State createState() => _QRScanner2State();
}

class _QRScanner2State extends State<QRScanner2> {
  List<DemoItem<dynamic>> _demoItems;
  var _isVisible;

  @override
  void initState() {
    super.initState();
    _demoItems = <DemoItem<dynamic>>[
      DemoItem<Event>(
          name: 'DayOf Event',
          value: Event.Check_In_No_Delayed,
          hint: 'Select Event',
          valueToString: (Event location) => location.toString().split('.')[1],
          builder: (DemoItem<Event> item) {
            void close() {
              setState(() {
                item.isExpanded = false;
              });
            }

            return Form(
              child: Builder(
                builder: (BuildContext context) {
                  return CollapsibleBody(
                    onSave: () {
                      Form.of(context).save();
                      close();
                    },
                    onCancel: () {
                      Form.of(context).reset();
                      close();
                    },
                    child: FormField<Event>(
                      initialValue: item.value,
                      onSaved: (Event result) {
                        item.value = result;
                      },
                      builder: (FormFieldState<Event> field) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RadioListTile<Event>(
                              value: Event.Check_In_No_Delayed,
                              title: const Text(
                                  'Check-In (Warn if Delayed Entry)'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Check_In,
                              title: const Text('Check-In'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Lunch_1,
                              title: const Text('Lunch-1'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Dinner,
                              title: const Text('Dinner'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.T_Shirt,
                              title: const Text('T-Shirts'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Midnight_Meal,
                              title: const Text('Midnight-Meal'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Midnight_Surprise,
                              title: const Text('Midnight-Surprise'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Breakfast,
                              title: const Text('Breakfast'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                            RadioListTile<Event>(
                              value: Event.Lunch_2,
                              title: const Text('Lunch-2'),
                              groupValue: field.value,
                              onChanged: (Event value) {
                                field.didChange(value);
                                setState(() {
                                  item.value = value;
                                  close();
                                });
                              },
                              activeColor: pink,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pink,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SafeArea(
                top: false,
                bottom: false,
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                  child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _demoItems[index].isExpanded = !isExpanded;
                        });
                      },
                      animationDuration: Duration(milliseconds: 100),
                      children: _demoItems
                          .map<ExpansionPanel>((DemoItem<dynamic> item) {
                        Event event = item.value;
                        print(event
                            .toString()
                            .substring(event.toString().indexOf('.') + 1));
                        QRScanner2.event = event
                            .toString()
                            .substring(event.toString().indexOf('.') + 1);

                        if (item.isExpanded) {
                          _isVisible = false;
                        } else {
                          _isVisible = true;
                        }

                        return ExpansionPanel(
                            isExpanded: item.isExpanded,
                            headerBuilder: item.headerBuilder,
                            body: item.build());
                      }).toList()),
                ),
              ),
              Container(
                alignment: Alignment(0.0, 0.0),
                height: 500.0,
                child: FlareActor(
                  'assets/Filip.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "idle",
                ),
              ),
            ],
          ),
        ],
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
                    FontAwesomeIcons.camera,
                    color: pink,
                    semanticLabel: 'Camera Icon',
                  ),
                ),
                label: Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: pink,
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
