import 'dart:convert';
import 'dart:io';

import 'package:HackRU/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<void> deleteCredentials() async {
  final SharedPreferences prefs = await _prefs;
  await prefs.remove('AUTH_TOKEN');
  await prefs.remove('EMAIL');
  await Future.delayed(Duration(seconds: 1));
  return;
}

Future<void> persistCredentials(String kAuthToken, String kEmail) async {
  final SharedPreferences prefs = await _prefs;
  await prefs.setString('AUTH_TOKEN', kAuthToken);
  await prefs.setString('EMAIL', kEmail);
  await Future.delayed(Duration(seconds: 1));
  return;
}

Future<bool> hasCredentials() async {
  final SharedPreferences prefs = await _prefs;
  if (prefs.containsKey('AUTH_TOKEN')) {
    return true;
  }
  await Future.delayed(Duration(seconds: 1));
  return false;
}

Future<String> getAuthToken() async {
  final SharedPreferences prefs = await _prefs;
  if (prefs.containsKey('AUTH_TOKEN')) {
    return prefs.getString('AUTH_TOKEN');
  }
  await Future.delayed(Duration(seconds: 1));
  return '';
}

Future<String> getEmail() async {
  final SharedPreferences prefs = await _prefs;
  if (prefs.containsKey('EMAIL')) {
    return prefs.getString('EMAIL');
  }
  await Future.delayed(Duration(seconds: 1));
  return '';
}


///================= STORING SLACK MESSAGES =================

Future<String> _appPath() async {
  return (await getApplicationDocumentsDirectory()).path;
}

Future<File> storedFile(String name) async {
  var path = (await _appPath()) + "/" + name;
  var f = File(path);
  if (!(await f.exists())) {
    await f.create();
  }
  return f;
}

Future<File> storedSlacksFile() => storedFile("slacks.json");

Future<List<Announcement>> getStoredSlacks() async {
  var slacksFile = await storedSlacksFile();
  var contents = await slacksFile.readAsString();
  if (contents == "") {
    return null;
  }
  List<dynamic> decoded = json.decode(contents);
  return decoded.map((slack) => Announcement.fromJson(slack)).toList();
}

setStoredSlacks(List<Announcement> slacks) async {
  var slacksFile = await storedSlacksFile();
  var slacksString =
      "[" + slacks.map((slack) => slack.toString()).toList().join(",") + "]";
  await slacksFile.writeAsString(slacksString);
}

Future<void> deleteStoredSlacks() async {
  var slacksFile = await storedSlacksFile();
  await slacksFile.delete();
}