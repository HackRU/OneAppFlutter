import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:HackRU/colors.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()
        ..onTap = () => launcher.launch(url));
}

class RichTextView extends StatelessWidget {
  final String text;

  RichTextView({@required this.text});

  bool _isTag(String input){
    final matcher = new RegExp(
        r"<!everyone>|<!channel>"
    );
    return matcher.hasMatch(input);
  }

  bool _isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  bool _isEmoji(String input) {
    final matcher = new RegExp(
        r"(\:.*?\:)");
    return matcher.hasMatch(input);
  }

  bool _isUserTag(String input) {
    final matcher = new RegExp(
        r"(\<@U.*?\>)");
    return matcher.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(fontSize: 15.0, color: bluegrey_dark,);
    final words = text.split(' ');
    List<TextSpan> span = [];
    words.forEach((word) {
      if(_isLink(word)){
        var eWord = word.replaceAll(new RegExp(r'[<>]'), '');
        span.add(
            new LinkTextSpan(
            style: _style.copyWith(color: green_tab, fontWeight: FontWeight.w500),
            url: eWord,
            text: '$eWord ',)
        );
      }
      else if(_isEmoji(word)){
        span.add(new TextSpan(text: '', style: _style));
      }
      else if(_isTag(word)){
        span.add(new TextSpan(text: '', style: _style));
      }
      else if(_isUserTag(word)){
        span.add(new TextSpan(text: '', style: _style));
      }
      else{
        span.add(new TextSpan(text: '$word ', style: _style));
      }

    });
    if (span.length > 0) {
      return new RichText(
        text: new TextSpan(text: '', children: span, style: TextStyle(fontSize: 15.0, color: bluegrey_dark,)),
      );
    } else {
      return new Text(text, style: TextStyle(fontSize: 15.0, color: bluegrey_dark,),);
    }
  }
}