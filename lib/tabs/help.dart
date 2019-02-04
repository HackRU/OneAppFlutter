import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = 'https://hackru.org/';
    return Column(children: <Widget>[
      RaisedButton.icon(
        icon: Icon(Icons.open_in_new),
        label: Text('HackRU'),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          this._openInWebview('${this._controller.text}');
        },
      ),
    ],
    );
  }

  Future<Null> _openInWebview(String url) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => WebviewScaffold(
            initialChild: Center(child: CircularProgressIndicator()),
            url: url,
            appBar: AppBar(title: Text(url)),
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('URL $url CAN NOT BE LAUNCHED!'),),
      );
    }
  }
}