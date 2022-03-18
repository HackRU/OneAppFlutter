import 'package:HackRU/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle? style, String? url, String? text})
      : super(
          style: style,
          text: text ?? url,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launcher.launch(url!),
        );
}

class StringParser extends StatelessWidget {
  final String? text;

  StringParser({@required this.text});

  bool _isTag(String input) {
    final matcher = RegExp(r'<!everyone>|<!channel>|<!here>|<!>');
    return matcher.hasMatch(input);
  }

  bool _isLink(String input) {
    final matcher = RegExp(
        r'(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');
    final specialChar = RegExp('/');
    return matcher.hasMatch(input) && specialChar.hasMatch(input);
  }

  bool _isEmoji(String input) {
    final matcher = RegExp(r'(\:.*?\:)');
    final moreEmoji = RegExp(r'(\.*?\:.*?\:.*?)');
    return matcher.hasMatch(input) || moreEmoji.hasMatch(input);
  }

  bool _isUserTag(String input) {
    final matcher = RegExp(r'(\<@U.*?\>)');
    final hashtag = RegExp(r'(\<#.*?\>)');
    return matcher.hasMatch(input) || hashtag.hasMatch(input);
  }

  bool _isEmail(String input) {
    final matcher = RegExp(r'(\<mailto:.*?\>.*?)');
    return matcher.hasMatch(input);
  }

  bool _isBold(String input) {
    final matcher1 = RegExp(r'(\*.*?)');
    final matcher2 = RegExp(r'(.*?\*)');
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  bool _isItalics(String input) {
    final matcher1 = RegExp(r'(\_.*?)');
    final matcher2 = RegExp(r'(.*?\_)');
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  bool _isStrikethrough(String input) {
    final matcher1 = RegExp(r'(\~.*?)');
    final matcher2 = RegExp(r'(.*?\~)');
    return matcher1.hasMatch(input) || matcher2.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    var _brightnessValue = MediaQuery.of(context).platformBrightness;

    final _style = TextStyle(
      fontSize: 18.0,
      color: _brightnessValue == Brightness.light
          ? HackRUColors.charcoal_light
          : HackRUColors.white,
      fontWeight: FontWeight.w700,
    );
    final _boldStyle = TextStyle(
      fontSize: 18.0,
      color: _brightnessValue == Brightness.light
          ? HackRUColors.charcoal_light
          : HackRUColors.white,
      fontWeight: FontWeight.bold,
    );
    final _italicsStyle = TextStyle(
      fontSize: 18.0,
      color: _brightnessValue == Brightness.light
          ? HackRUColors.charcoal_light
          : HackRUColors.white,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
    );
    final _strikeThroughStyle = TextStyle(
      fontSize: 18.0,
      color: _brightnessValue == Brightness.light
          ? HackRUColors.charcoal_light
          : HackRUColors.white,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
    );

    final words = text?.split(' ');
    var span = <TextSpan>[];

    words?.forEach((word) {
      if (_isLink(word)) {
        var eWord = word.replaceAll(RegExp(r'[<>]'), '');
        span.add(LinkTextSpan(
          style: _style.copyWith(
            color: _brightnessValue == Brightness.light
                ? HackRUColors.pink
                : HackRUColors.yellow,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
          url: eWord,
          text: '$eWord ',
        ));
      } else if (_isEmoji(word)) {
        span.add(TextSpan(text: '', style: _style));
      } else if (_isTag(word)) {
        span.add(TextSpan(text: '', style: _style));
      } else if (_isUserTag(word)) {
        span.add(TextSpan(text: '', style: _style));
      } else if (_isBold(word)) {
        var eWord = word.replaceAll('*', '');
        span.add(TextSpan(text: '$eWord ', style: _boldStyle));
      } else if (_isItalics(word)) {
        var eWord = word.replaceAll('_', '');
        span.add(TextSpan(text: '$eWord ', style: _italicsStyle));
      } else if (_isStrikethrough(word)) {
        var eWord = word.replaceAll('~', '');
        span.add(TextSpan(text: '$eWord ', style: _strikeThroughStyle));
      } else if (_isEmail(word)) {
        var eWord = word.replaceAll(RegExp(r'[<>]'), '');
        var rWord = eWord.replaceAll(RegExp(r'(.*?\|)'), '');
        span.add(TextSpan(text: '$rWord ', style: _boldStyle));
      } else {
        span.add(TextSpan(text: '$word ', style: _style));
      }
    });
    if (span.isNotEmpty) {
      return RichText(
        text: TextSpan(
          children: span,
          style: DefaultTextStyle.of(context).style,
        ),
      );
    } else {
      return Text(
        text!,
        style: TextStyle(
          fontSize: 15.0,
          color: _brightnessValue == Brightness.light
              ? HackRUColors.pink_dark
              : HackRUColors.yellow,
        ),
      );
    }
  }
}
