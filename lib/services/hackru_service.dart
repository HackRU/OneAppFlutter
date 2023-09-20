import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackru/defaults.dart';
import 'package:hackru/models/exceptions.dart';
import 'package:hackru/models/models.dart';
import 'package:http/http.dart' as http;

var client = http.Client();
final kHeader = {'Content-Type': 'application/json'};

///========================================================
///                     HTTP Requests
///========================================================

Future<http.Response> getMisc(String endpoint) {
  return client.get(Uri.parse(MISC_URL + endpoint));
}

Future<http.Response> getLcs(String endpoint) {
  return client
      .get(Uri.parse(BASE_URL + endpoint))
      .timeout(const Duration(seconds: 30));
}

Future<http.Response> postLcs(String endpoint, dynamic kBody) async {
  var encodedBody = jsonEncode(kBody);
  // debugPrint('try: kBody');
  var result = await client
      .post(Uri.parse(BASE_URL + endpoint), headers: kHeader, body: encodedBody)
      .timeout(const Duration(seconds: 10));

  var decoded = jsonDecode(result.body);
  // debugPrint('${result.statusCode} $decoded');
  if (decoded['statusCode'] != result.statusCode) {
    // print(decoded);
    // print(
    //     '!!!!!!!!!!!!WARNING\nBody and Container status code dissagree actual ${result.statusCode} body: ${decoded['statusCode']}\n');
    // print(endpoint);
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

// List<String> qrEvents(String miscUrl) async {
// var response = await getMisc('/events.json');
// var events = [
//   "check-in",
//   "check-in-no-delayed",
//   "lunch-1",
//   "dinner",
//   "t-shirts",
//   "midnight-meal",
//   "midnight-surprise",
//   "breakfast",
//   "lunch-2",
//   "raffle",
//   "ctf-1",
//   "ctf-2"
// ];
var qrEvents = json.encode(events);
// var qrEvents = List<String>.from(resources);
// return qrEvents;
// }

///========================================================
///                     GET REQUESTS
///========================================================

Future<List<Map>> slackResources() async {
  Map resources;
  var tsNow = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

  // await Future.delayed(Duration(seconds: 3));
  // return [
  //   <String, String>{
  //     'text': "Testing announcements out",
  //     'ts': (DateTime.now().millisecondsSinceEpoch / 1000).toString(),
  //   }
  // ];

  try {
    var response = await getLcs('/dayof-slack');
    resources = json.decode(response.body);
    // print('======== res: ' + response.body);
  } on TimeoutException catch (_) {
    return [
      <String, String>{
        'text': 'Error: Request time out.',
        'ts': '0.0',
      }
    ];
  } on Exception catch (_) {
    return [
      <String, String>{
        'text': 'Error: Unable to retrieve messages.',
        'ts': '0.0',
      }
    ];
  }

  if (resources['statusCode'] == 400) {
    return [
      <String, String>{
        'text': 'Error: Unable to retrieve messages.',
        'ts': '0.0',
      }
    ];
  }
  return resources['body'] is List
      ? (resources['body'] as List)
          .where((resource) => resource['text'] != null)
          .map((resource) => resource as Map)
          .toList()
      : [];
}

Future<List<Event>> dayofEventsResources() async {
  var response = await getLcs('/dayof-events');
  var resources = json.decode(response.body);
  if (resources['body'] == null || (resources['body'] as List).isEmpty) {
    return [
      Event(
        summary: 'Coming Soon',
        start: DateTime.fromMillisecondsSinceEpoch(1693716897931),
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
// Look at LcsCredential class and figure out a way to enable commented code
// because you'll need "email" and "token_expiry_dateTime"
// if LCS doesn't return these info, then you'd have to call /read userData
// right after successful /login call here and retrieve necessary userData from
// there.
Future<LcsCredential> login(String email, String password) async {
  var result = await postLcs('/authorize', {
    'email': email,
    'password': password,
  });
  var body = jsonDecode(result.body);
  // quirk with lcs where it puts the actual result as a string
  // inside the normal body
  // print('==== TOKEN: ${json.encode(body['body']['token'])}');
  if (body['statusCode'] == 200) {
    // return LcsCredential(json.encode(body['body']['token']));
    return LcsCredential.fromJson(body['body']);
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
  // print('===##==== user: ${jsonDecode(result.body)}');
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

Future updateStatus(String lcsUrl, String authE, String authT,
    String userEmailOrId, String nextState) async {
  var result = await postLcs('/update', {
    'updates': {
      '\$set': {'registration_status': nextState}
    },
    'user_email': userEmailOrId,
    'auth_email': authE,
    'token': authT
  });

  var decoded = jsonDecode(result.body);
  if (decoded['statusCode'] == 400) {
    throw UpdateError(decoded['body']);
  } else if (decoded['statusCode'] == 403) {
    throw PermissionError();
  } else if (decoded['statusCode'] != 200) {
    throw LcsError(result);
  }
}

/// TODO: Fix this
// /update can give wrong status codes
// check if the user credential belongs to is role.director first. or else it will break :(
void updateUserDayOf(
    String lcsUrl, LcsCredential credential, User user, String event) async {
  // print(event);
  var result = await postLcs('/update', {
    'updates': {
      '\$set': {'day_of.$event': true}
    },
    'user_email': user.email,
    'aut_email': user.email,
    'token': credential.token,
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

Future<int> attendEvent(String lcsUrl, String _authE, String _authT,
    String userEmailOrId, String event, bool again) async {
  // debugPrint(event);
  // debugPrint(
  //     'Attend even called with \n auth: $_authE \n token: $_authT \n for user: $userEmailOrId \n for the event: $event');
  var result = await postLcs('/attend-event', {
    'auth_email': _authE, //TODO: figure out how to get auth_email here
    'qr': userEmailOrId,
    'token': _authT,
    'event': event,
    'again': again
  });
  // debugPrint('Attend event received ${result.body}');
  var body = json.decode(result.body);
  if (body['statusCode'] == 200) {
    var resp = body['body']['new_count'];
    // debugPrint('====== in 200 responsebody $resp');
    return resp;
  } else if (body['statusCode'] == 402) {
    throw UserCheckedEvent();
  } else if (body['statusCode'] == 404) {
    throw UserNotFound();
  } else {
    throw LcsError(result);
  }
}

void linkQR(String lcsUrl, String _authE, String _authT, String userEmailOrId,
    String hashQR) async {
  // debugPrint('linkQR called: $hashQR');
  // debugPrint('$_authE $_authT $userEmailOrId');
  var result = await postLcs('/link-qr', {
    'auth_email': _authE, // figure out how to get auth email here
    'email': userEmailOrId,
    'token': _authT,
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

Future<bool> isAuthorizedForQRScanner(String token, String email) async {
  var userProfile = await getUser(token, email);
  if (userProfile.role.organizer == true ||
      userProfile.role.organizer == true) {
    return true;
  } else {
    return false;
  }
}

Future<int> getRegistered(String _token) async {
  var result = await postLcs('/read', {
    'token': _token,
    'query': {'registration_status': 'registered'},
    'aggregate': false
  });

  if (result.statusCode == 200) {
    var users = jsonDecode(result.body)['body'];
    return users.length;
  } else {
    throw LcsError(result);
  }
}

Future<int> getAttending(String _token) async {
  var result = await postLcs('/read', {
    'token': _token,
    'query': {'registration_status': 'checked-in'},
    'aggregate': false
  });

  if (result.statusCode == 200) {
    var users = jsonDecode(result.body)['body'];
    return users.length;
  } else {
    throw LcsError(result);
  }
}

Future<int> forgotPassword(String _email) async {
  var result =
      await postLcs('/createmagiclink', {'email': _email, 'forgot': true});

  if (result.statusCode == 200) {
    return 200;
  } else {
    throw LcsError(result);
  }
}

void main() {
  Future<void> testCall(email, password) async {
    LcsCredential cred = await login(email, password);
    // print('====== token/email: ${cred.token} / $email');

    User user = await getUser(cred.token, email);
    // print('====== user: ${user.toJson()}');
  }

  testCall('a@a.com', 'a');
}
