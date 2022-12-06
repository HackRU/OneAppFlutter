import 'dart:convert';

import 'package:hackru/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CredManager {
  CredManager(this.prefs);
  Box prefs;

  void deleteCredentials() {
    prefs.delete('AUTH_TOKEN');
    prefs.delete('EMAIL');
  }

  void persistCredentials(String kAuthToken, String kEmail) {
    prefs.put('AUTH_TOKEN', kAuthToken);
    prefs.put('EMAIL', kEmail);
  }

  bool hasCredentials() {
    if (prefs.containsKey('AUTH_TOKEN')) {
      return true;
    }
    return false;
  }

  String getAuthToken() {
    if (prefs.containsKey('AUTH_TOKEN')) {
      return prefs.get('AUTH_TOKEN');
    }
    return '';
  }

  String getEmail() {
    if (prefs.containsKey('EMAIL')) {
      return prefs.get('EMAIL');
    }
    return '';
  }

  void persistSlackAnnouncements(List<Announcement> slacks) {
    var tsNow = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    var slacksMsgs = slacks.length > 1
        ? jsonEncode(slacks)
        : '[{"text": "Error: Unable to retrieve messages!", "ts": "$tsNow"}]';
    prefs.put('SLACK_ANNOUNCEMENTS', slacksMsgs);
  }

  List<Announcement> getSlackAnnouncements() {
    var messages = List<Announcement>.empty();
    if (prefs.containsKey('SLACK_ANNOUNCEMENTS')) {
      var decoded = json.decode(prefs.get('SLACK_ANNOUNCEMENTS')!);
      messages = decoded
          .map<Announcement>((slack) => Announcement.fromJson(slack))
          .toList();
    }
    return messages;
  }

  void deleteSlackAnnouncements() {
    prefs.delete('SLACK_ANNOUNCEMENTS');
  }
}
