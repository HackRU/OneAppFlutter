import 'dart:convert';

import 'package:HackRU/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<void> deleteCredentials() async {
  final prefs = await _prefs;
  await prefs.remove('AUTH_TOKEN');
  await prefs.remove('EMAIL');
  await Future.delayed(Duration(seconds: 1));
  return;
}

Future<void> persistCredentials(String kAuthToken, String kEmail) async {
  final prefs = await _prefs;
  await prefs.setString('AUTH_TOKEN', kAuthToken);
  await prefs.setString('EMAIL', kEmail);
  await Future.delayed(Duration(seconds: 1));
  return;
}

Future<bool> hasCredentials() async {
  final prefs = await _prefs;
  if (prefs.containsKey('AUTH_TOKEN')) {
    return true;
  }
  await Future.delayed(Duration(seconds: 1));
  return false;
}

Future<String> getAuthToken() async {
  final prefs = await _prefs;
  if (prefs.containsKey('AUTH_TOKEN')) {
    return prefs.getString('AUTH_TOKEN');
  }
  await Future.delayed(Duration(seconds: 1));
  return '';
}

Future<String> getEmail() async {
  final prefs = await _prefs;
  if (prefs.containsKey('EMAIL')) {
    return prefs.getString('EMAIL');
  }
  await Future.delayed(Duration(seconds: 1));
  return '';
}

Future<void> persistSlackAnnouncements(List<Announcement> slacks) async {
  var tsNow = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

  final prefs = await _prefs;
  var slacksMsgs = slacks.length > 1
      ? jsonEncode(slacks)
      : '[{"text": "Error: Unable to retrieve messages!", "ts": "$tsNow"}]';
  await prefs.setString('SLACK_ANNOUNCEMENTS', slacksMsgs);
  await Future.delayed(Duration(seconds: 1));
}

Future<List<Announcement>> getSlackAnnouncements() async {
  final prefs = await _prefs;
  if (prefs.containsKey('SLACK_ANNOUNCEMENTS')) {
    var decoded = json.decode(prefs.getString('SLACK_ANNOUNCEMENTS'));
    return decoded
        .map<Announcement>((slack) => Announcement.fromJson(slack))
        .toList();
  }
  return null;
}

Future<void> deleteSlackAnnouncements() async {
  final prefs = await _prefs;
  await prefs.remove('SLACK_ANNOUNCEMENTS');
  await Future.delayed(Duration(seconds: 1));
  return;
}
