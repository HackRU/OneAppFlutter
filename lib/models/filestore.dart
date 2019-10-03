import 'dart:convert';
import 'dart:io';

import 'package:HackRU/models/models.dart';
import 'package:path_provider/path_provider.dart';

Future<String> _appPath() async {
  return (await getApplicationDocumentsDirectory()).path;
}

Future<File> storedFile(String name) async {
  var path = (await _appPath()) + "/" + name;
  var f = await File(path);
  if (!(await f.exists())) {
    await f.create();
  }
  return f;
}

Future<File> storedCredentialFile() => storedFile("credential.json");

Future<File> storedSlacksFile() => storedFile("slacks.json");

Future<LcsCredential> getStoredCredential() async {
  var credFile = await storedCredentialFile();
  var contents = await credFile.readAsString();
  if (contents == "") {
    return null;
  }
  var decoded = json.decode(contents);
  return LcsCredential.fromJson(decoded);
}

void setStoredCredential(LcsCredential cred) async {
  var credFile = await storedCredentialFile();
  await credFile.writeAsString(cred.jsonString());
}

void deleteStoredCredential() async {
  var credFile = await storedCredentialFile();
  await credFile.delete();
}

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
