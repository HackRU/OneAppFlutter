import 'package:HackRU/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () => launcher.launch(url));
}

class StringParser extends StatelessWidget {
  final String text;

  StringParser({@required this.text});

  bool _isTag(String input) {
    final matcher = new RegExp(r"<!everyone>|<!channel>|<!here>|<!>");
    return matcher.hasMatch(input);
  }

  bool _isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    final specialChar = new RegExp("/");
    return matcher.hasMatch(input) && specialChar.hasMatch(input);
  }

  bool _isEmoji(String input) {
    final matcher = new RegExp(r"(\:.*?\:)");
    final moreEmoji = new RegExp(r"(\.*?\:.*?\:.*?)");
    return matcher.hasMatch(input) || moreEmoji.hasMatch(input);
  }

  bool _isUserTag(String input) {
    final matcher = new RegExp(r"(\<@U.*?\>)");
    final hashtag = new RegExp(r"(\<#.*?\>)");
    return matcher.hasMatch(input) || hashtag.hasMatch(input);
  }

  bool _isEmail(String input) {
    final matcher = new RegExp(r"(\<mailto:.*?\>.*?)");
    return matcher.hasMatch(input);
  }

  bool _isBold(String input) {
    final matcher1 = new RegExp(r"(\*.*?)");
    final matcher2 = new RegExp(r"(.*?\*)");
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  bool _isItalics(String input) {
    final matcher1 = new RegExp(r"(\_.*?)");
    final matcher2 = new RegExp(r"(.*?\_)");
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  bool _isStrikethrough(String input) {
    final matcher1 = new RegExp(r"(\~.*?)");
    final matcher2 = new RegExp(r"(.*?\~)");
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
      fontSize: 15.0,
      color: off_white,
      fontWeight: FontWeight.w400,
    );
    final _boldStyle = TextStyle(
      fontSize: 15.0,
      color: off_white,
      fontWeight: FontWeight.w800,
    );
    final _italicsStyle = TextStyle(
      fontSize: 15.0,
      color: off_white,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
    );
    final _strikeThroughStyle = TextStyle(
      fontSize: 15.0,
      color: off_white,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
    );

    final words = text.split(' ');
    List<TextSpan> span = [];

    words.forEach((word) {
      if (_isLink(word)) {
        var eWord = word.replaceAll(new RegExp(r'[<>]'), '');
        span.add(new LinkTextSpan(
          style: _style.copyWith(
            color: weblink,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
          url: eWord,
          text: '$eWord ',
        ));
      } else if (_isEmoji(word)) {
        span.add(new TextSpan(text: '', style: _style));
      } else if (_isTag(word)) {
        span.add(new TextSpan(text: '', style: _style));
      } else if (_isUserTag(word)) {
        span.add(new TextSpan(text: '', style: _style));
      } else if (_isBold(word)) {
        var eWord = word.replaceAll('*', '');
        span.add(new TextSpan(text: '$eWord ', style: _boldStyle));
      } else if (_isItalics(word)) {
        var eWord = word.replaceAll('_', '');
        span.add(new TextSpan(text: '$eWord ', style: _italicsStyle));
      } else if (_isStrikethrough(word)) {
        var eWord = word.replaceAll('~', '');
        span.add(new TextSpan(text: '$eWord ', style: _strikeThroughStyle));
      } else if (_isEmail(word)) {
        var eWord = word.replaceAll(new RegExp(r'[<>]'), '');
        var rWord = eWord.replaceAll(new RegExp(r"(.*?\|)"), '');
        span.add(new TextSpan(text: '$rWord ', style: _boldStyle));
      } else {
        span.add(new TextSpan(text: '$word ', style: _style));
      }
    });
    if (span.length > 0) {
      return new RichText(
        text: new TextSpan(
          children: span,
          style: DefaultTextStyle.of(context).style,
        ),
      );
    } else {
      return new Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
          color: pink_dark,
        ),
      );
    }
  }
}
