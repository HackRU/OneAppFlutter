import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import 'package:HackRU/models.dart';

Future<String> _appPath() async {
  return (await getApplicationDocumentsDirectory()).path;
}

Future<File> storedCredentialFile() async {
  var path = (await _appPath())+"/credential.json";
  var f = await File(path);
  if (!(await f.exists())) {
    await f.create();
  }
  return f;
}

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
