import 'dart:async';
import 'dart:convert';
import 'package:HackRU/defaults.dart';
import 'package:HackRU/models/exceptions.dart';
import 'package:HackRU/models/models.dart';
import 'package:http/http.dart' as http;

var client = http.Client();
final kHeader = {'Content-Type': 'application/json'};

///========================================================
///                     HTTP Requests
///========================================================

Future<http.Response> getMisc(String endpoint) {
  return client.get(MISC_URL + endpoint);
}

Future<http.Response> getLcs(String endpoint) {
  return client.get(BASE_URL + endpoint).timeout(const Duration(seconds: 10));
}

Future<http.Response> postLcs(String endpoint, dynamic kBody) async {
  var encodedBody = jsonEncode(kBody);
  var result = await client
      .post(BASE_URL + endpoint, headers: kHeader, body: encodedBody)
      .timeout(const Duration(seconds: 10));

  var decoded = jsonDecode(result.body);
  if (decoded['statusCode'] != result.statusCode) {
    print(decoded);
    print(
        '!!!!!!!!!!!!WARNING\nBody and Container status code dissagree actual ${result.statusCode} body: ${decoded['statusCode']}\n');
    print(endpoint);
  }
  return result;
}

///========================================================
///                     MISC REQUESTS
///========================================================

Future<List<String>> siteMap(String miscUrl) async {
  var response = await getMisc('/');
  return await response.body.split('\n');
}

Future<List<String>> events(String miscUrl) async {
  var response = await getMisc('/events.txt');
  return await response.body.split('\n');
}

Future<String> labelUrl(String miscUrl) async {
  var response = await getMisc('/label-url.txt');
  // In case there is a line character at the end, remove it (there was before)
  return response.body.replaceAll('\n', '');
}

Future<List<HelpResource>> helpResources(String miscUrl) async {
  var response = await getMisc('/resources.json');
  var resources = json.decode(response.body);
  return resources
      .map<HelpResource>((resource) => HelpResource.fromJson(resource))
      .toList();
}

Future<List<String>> qrEvents(String miscUrl) async {
  var response = await getMisc('/events.json');
  var resources = json.decode(response.body);
  var qrEvents = List<String>.from(resources);
  return qrEvents;
}

///========================================================
///                     GET REQUESTS
///========================================================

Future<List<Announcement>> slackResources() async {
  var resources;
  var tsNow = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

  ///TODO: check all requests for TimeOutException
  try {
    var response = await getLcs('/dayof-slack');
    resources = json.decode(response.body);
  } on TimeoutException catch (_) {
    return [
      Announcement(
        text: 'Sorry, request timedout! [Error 408]',
        ts: tsNow,
      )
    ];
  }
  if (resources['body'].length <= 3) {
    if (resources['body']['statusCode'] == 400) {
      return [
        Announcement(
          text: 'Error: Unable to retrieve messages!',
          ts: tsNow,
        )
      ];
    }
  }
  return resources['body']
      .where((resource) => resource['text'] != null)
      .map<Announcement>((resource) => Announcement.fromJson(resource))
      .toList();
}

Future<List<Event>> dayofEventsResources() async {
  var response = await getLcs('/dayof-events');
  var resources = json.decode(response.body);
//  print(resources);
  if (resources['body'] == null) {
    return [
      Event(
        summary: 'Coming Soon',
        start: DateTime.now(),
        location: 'hackru_logo',
      )
    ];
  }
  return resources['body']
      .map<Event>((resource) => Event.fromJson(resource))
      .toList();
}

///========================================================
///                     POST REQUESTS
///========================================================

/// TODO: Fix this
// authorize can give wrong status codes
Future<LcsCredential> login(String email, String password) async {
  var result = await postLcs('/authorize', {
    'email': email,
    'password': password,
  });
  var body = jsonDecode(result.body);
  // quirk with lcs where it puts the actual result as a string
  // inside the normal body
  if (body['statusCode'] == 200) {
    return LcsCredential.fromJson(body['body']['auth']);
  } else if (body['statusCode'] == 403) {
    throw LcsLoginFailed();
  } else {
    throw LcsError(result);
  }
}

Future<User> getUser(String authToken, String emailAddress,
    [String targetEmail = 'MAGIC_MAN']) async {
  if (targetEmail == null) {
    throw ArgumentError('null email');
  }
  if (targetEmail == 'MAGIC_MAN') {
    targetEmail = emailAddress;
  }
  var result = await postLcs('/read', {
    'email': emailAddress,
    'token': authToken,
    'query': {'email': targetEmail}
  });
  if (result.statusCode == 200) {
    var users = jsonDecode(result.body)['body'];
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
  var result = await postLcs('/update', {
    'updates': {
      '\$set': {'day_of.$event': true}
    },
    'user_email': user.email,
    'auth_email': credential.email,
    'auth': credential.token,
  });

  var decoded = jsonDecode(result.body);
  if (decoded['statusCode'] == 400) {
    throw UpdateError(decoded['body']);
  } else if (decoded['statusCode'] == 403) {
    // BROKEN BECAUSE LCS
    throw PermissionError();
  } else if (decoded['statusCode'] != 200) {
    throw LcsError(result);
  }
}

Future<int> attendEvent(String lcsUrl, LcsCredential credential,
    String userEmailOrId, String event, bool again) async {
  print(event);
  var result = await postLcs('/attend-event', {
    'auth_email': credential.email,
    'qr': userEmailOrId,
    'token': credential.token,
    'event': event,
    'again': again
  });

  var body = jsonDecode(result.body);
  if (body['statusCode'] == 200) {
    return body['body']['_count'];
  } else if (body['statusCode'] == 402) {
    throw UserCheckedEvent();
  } else if (body['statusCode'] == 404) {
    throw UserNotFound();
  } else {
    throw LcsError(result);
  }
}

void linkQR(String lcsUrl, LcsCredential credential, String userEmailOrId,
    String hashQR) async {
  print(hashQR);
  var result = await postLcs('/link-qr', {
    'auth_email': credential.email,
    'email': userEmailOrId,
    'token': credential.token,
    'qr_code': hashQR
  });

  var decoded = jsonDecode(result.body);
  if (decoded['statusCode'] == 404) {
    throw UserNotFound();
  } else if (decoded['statusCode'] == 403) {
    throw PermissionError();
  } else if (decoded['statusCode'] != 200) {
    throw LcsError(result);
  }
}
