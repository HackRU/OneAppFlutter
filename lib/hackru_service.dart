import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:HackRU/models.dart';

const _lcsUrl = 'https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test'; // prod
//const _lcsUrl = 'https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test'; // test
const _miscUrl = 'http://hackru-misc.s3-website-us-west-2.amazonaws.com';

var client = new http.Client();

Future<http.Response> getMisc(String endpoint) {
  return client.get(_miscUrl + endpoint);
}

String toParam(LcsCredential credential) {
  var param = "";
  if (credential != null) {
    if (credential.isExpired()) {
      throw CredentialExpired();
    }
    param = "?token="+credential.token;
  }
  return param;
}

Future<http.Response> getLcs(String endpoint, [LcsCredential credential]) {
  return client.get(_lcsUrl + endpoint + toParam(credential));
}

Future<http.Response> postLcs(String endpoint, dynamic body, [LcsCredential credential]) {
  var encodedBody = jsonEncode(body);
  return client.post(_lcsUrl + endpoint + toParam(credential),
    headers: {"content-Type": "applicationi/json"},
    body: encodedBody
  );
}

// misc functions
Future<List<String>> sitemap() async {
  var response = await getMisc("/");
  return await response.body.split("\n");
}

Future<List<String>> events() async {
  var response = await getMisc("/events.txt");
  return await response.body.split("\n");
}

Future<String> labelUrl() async {
  var response = await getMisc("/label-url.txt");
  return response.body;
}

Future<List<HelpResource>> helpResources() async {
  var response =  await getMisc("/resources.json");
  var resources = json.decode(response.body);
  return resources.map<HelpResource>(
    (resource) => new HelpResource.fromJson(resource)
  ).toList();
}

// lcs functions

Future<LcsCredential> login(String email, String password) async {
  var result = await postLcs("/authorize", {
      "email": email,
      "password": password,
  });
  var body = jsonDecode(result.body);
  // quirk with lcs where it puts the actual result as a string
  // inside the normal body
  if (body["statusCode"] == 200) {
    var auth = jsonDecode(body["body"])["auth"];
    return LcsCredential.fromJson(auth);
  } else if (body["statusCode"] == 403) {
    throw LcsLoginFailed();
  } else {
    throw LcsError;
  }
}
// not yet working

Future<User> getUser(LcsCredential credential, [String targetEmail]) async {
  if (targetEmail == null) {
    targetEmail = credential.email;
  }
  var result = await postLcs("/read", {
      "email": credential.email,
      "token": credential.token,
      "query": {"\$match":{"email": targetEmail}}
  },credential);
  if (result.statusCode == 200) {
    var firstUser = jsonDecode(result.body)["body"][0];
    return User.fromJson(firstUser);
  } else {
    throw LcsError();
  }
}
