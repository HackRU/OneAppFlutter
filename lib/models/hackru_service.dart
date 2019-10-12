import 'dart:convert';

import 'package:HackRU/models/models.dart';
import 'package:http/http.dart' as http;

///******************** HTTP Requests ********************

var client = new http.Client();

Future<http.Response> getMisc(String miscUrl, String endpoint) {
  return client.get(miscUrl + endpoint);
}

String toParam(LcsCredential credential) {
  var param = "";
  if (credential != null) {
    if (credential.isExpired()) {
      throw CredentialExpired();
    }
    param = "?token=" + credential.token;
  }
  return param;
}

Future<http.Response> getLcs(String lcsUrl, String endpoint,
    [LcsCredential credential]) {
  return client.get(lcsUrl + endpoint + toParam(credential));
}

Future<http.Response> dayOfGetLcs(String lcsUrl, String endpoint,
    [LcsCredential credential]) {
  return client.get(lcsUrl + endpoint + toParam(credential));
}

Future<http.Response> dayOfEvents(String lcsUrl, String endpoint,
    [LcsCredential credential]) {
  return client.get(lcsUrl + endpoint + toParam(credential));
}

Future<http.Response> postLcs(String lcsUrl, String endpoint, dynamic body,
    [LcsCredential credential]) async {
  var encodedBody = jsonEncode(body);
  var result = await client.post(lcsUrl + endpoint + toParam(credential),
      headers: {"Content-Type": "application/json"}, body: encodedBody);
  var decoded = jsonDecode(result.body);
  if (decoded["statusCode"] != result.statusCode) {
    print(decoded);
    print("!!!!!!!!!!!!WARNING");
    print(
        "body and container status code dissagree actual ${result.statusCode} body: ${decoded['statusCode']}");
    print(endpoint);
  }
  return result;
}

///******************** misc functions ********************

Future<List<String>> sitemap(String miscUrl) async {
  var response = await getMisc(miscUrl, "/");
  return await response.body.split("\n");
}

Future<List<String>> events(String miscUrl) async {
  var response = await getMisc(miscUrl, "/events.txt");
  return await response.body.split("\n");
}

Future<String> labelUrl(String miscUrl) async {
  var response = await getMisc(miscUrl, "/label-url.txt");

  // In case there is a newline character at the end, remove it (there was before)
  return response.body.replaceAll("\n", "");
}

void printLabel(String email, String miscUrl, [String url]) async {
  if (url == null) {
    url = await labelUrl(miscUrl);
  }
  var response = await client.post(url,
      headers: {"Content-Type": "application/json"},
      body: "{\"email\": \"$email\"}");
  if (response.statusCode != 200) {
    throw LabelPrintingError();
  }
}

Future<List<HelpResource>> helpResources(String miscUrl) async {
  var response = await getMisc(miscUrl, "/resources.json");
  var resources = json.decode(response.body);
  return resources
      .map<HelpResource>((resource) => new HelpResource.fromJson(resource))
      .toList();
}

Future<List<String>> qrEvents(String miscUrl) async {
  var response = await getMisc(miscUrl, "/events.json");
  var resources = json.decode(response.body);
  List<String> qrEvents = new List<String>.from(resources);
  return qrEvents;
}

Future<List<Announcement>> slackResources(String lcsUrl) async {
  var response = await dayOfGetLcs(lcsUrl, '/dayof-slack');
  var resources = json.decode(response.body);
  print(resources);
  if (resources["body"] == null) {
    var tsnow = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    return [
      Announcement(
        text: "Nothing yet!",
        ts: tsnow,
      )
    ];
  }
  return resources["body"]
      .where((resource) => resource["text"] != null)
      .map<Announcement>((resource) => Announcement.fromJson(resource))
      .toList();
}

Future<List<Event>> dayofEventsResources(String lcsUrl) async {
  var response = await dayOfGetLcs(lcsUrl, '/dayof-events');
  var resources = json.decode(response.body);
  print(resources);
  if (resources["body"] == null) {
    return [
      Event(
        summary: "Coming Soon",
        start: DateTime.now(),
        location: 'hackru_logo',
      )
    ];
  }
  return resources["body"]
      .map<Event>((resource) => new Event.fromJson(resource))
      .toList();
}

///******************** lcs functions ********************

/// TODO: Fix this
// authorize can give wrong status codes
Future<LcsCredential> login(
    String email, String password, String lcsUrl) async {
  var result = await postLcs(lcsUrl, "/authorize", {
    "email": email,
    "password": password,
  });
  var body = jsonDecode(result.body);
  // quirk with lcs where it puts the actual result as a string
  // inside the normal body
  if (body["statusCode"] == 200) {
    return LcsCredential.fromJson(body["body"]["auth"]);
  } else if (body["statusCode"] == 403) {
    throw LcsLoginFailed();
  } else {
    throw LcsError(result);
  }
}

Future<User> getUser(String lcsUrl, LcsCredential credential,
    [String targetEmail = "MAGIC_MAN"]) async {
  if (targetEmail == null) {
    throw ArgumentError("null email");
  }
  if (targetEmail == "MAGIC_MAN") {
    targetEmail = credential.email;
  }
  var result = await postLcs(
      lcsUrl,
      "/read",
      {
        "email": credential.email,
        "token": credential.token,
        "query": {"email": targetEmail}
      },
      credential);
  if (result.statusCode == 200) {
    var users = jsonDecode(result.body)["body"];
    if (users.length < 1) {
      throw UserNotFound();
    }
    return User.fromJson(users[0]);
  } else if (result.statusCode == 404) {
    throw UserNotFound();
  } else {
    throw LcsError(result);
  }
}

/// TODO: Fix this
// /update can give wrong status codes
// check if the user credential belongs to is role.director first. or else it will break :(
void updateUserDayOf(
    String lcsUrl, LcsCredential credential, User user, String event) async {
  print(event);
  var result = await postLcs(
      lcsUrl,
      "/update",
      {
        "updates": {
          "\$set": {"day_of.$event": true}
        },
        "user_email": user.email,
        "auth_email": credential.email,
        "auth": credential.token,
      },
      credential);

  var decoded = jsonDecode(result.body);
  if (decoded["statusCode"] == 400) {
    throw UpdateError(decoded["body"]);
  } else if (decoded["statusCode"] == 403) {
    // BROKEN BECAUSE LCS
    throw PermissionError();
  } else if (decoded["statusCode"] != 200) {
    throw LcsError(result);
  }
}

Future<int> attendEvent(String lcsUrl, LcsCredential credential,
    String userEmailOrId, String event) async {
  print(event);
  var result = await postLcs(
      lcsUrl,
      "/attend-event",
      {
        "auth_email": credential.email,
        "qr": userEmailOrId,
        "token": credential.token,
        "event": event,
        "again": true
      },
      credential);

  var body = jsonDecode(result.body);
  if (body["statusCode"] == 200) {
    return body["body"]["new_count"];
  } else if (body["statusCode"] == 402) {
    throw UserCheckedEvent();
  } else if (body["statusCode"] != 404) {
    throw UserNotFound();
  } else {
    throw LcsError(result);
  }
}

void linkQR(String lcsUrl, LcsCredential credential, String userEmailOrId,
    String hashQR) async {
  print(hashQR);
  var result = await postLcs(
      lcsUrl,
      "/link-qr",
      {
        "auth_email": credential.email,
        "email": userEmailOrId,
        "token": credential.token,
        "qr_code": hashQR
      },
      credential);

  var decoded = jsonDecode(result.body);
  if (decoded["statusCode"] == 404) {
    throw UserNotFound();
  } else if (decoded["statusCode"] == 403) {
    throw PermissionError();
  } else if (decoded["statusCode"] != 200) {
    throw LcsError(result);
  }
}
