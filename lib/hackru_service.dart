import 'package:http/http.dart' as http;
import 'dart:convert';

const _lcsUrl = 'https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test';
const _miscUrl = 'http://hackru-misc.s3-website-us-west-2.amazonaws.com';

var client = new http.Client();

Future<http.Response> getMisc(String endpoint) {
  return client.get(_miscUrl + endpoint);
}

Future<http.Response> getLcs(String endpoint) {
  return client.get(_lcsUrl + endpoint);
}

Future<http.Response> postLcs(String endpoint, dynamic body) {
  var encodedBody = jsonEncode(body);
  return client.post(_lcsUrl + endpoint,
    headers: {"content-Type": "applicationi/json"},
    body: encodedBody
  );
}

// misc functions
Future<List<String>> sitemap() async {
  var response = await getMisc("/");
  return await response.body.split("\n");
}

class HelpResource {
  final String name;
  final String description;
  final String url;

  HelpResource(this.name, this.description, this.url);

  HelpResource.fromJson(Map<String, dynamic> json)
  : name = json['name'],
    description = json['desc'],
    url = json['url'];
}

Future<List<HelpResource>> helpResources() async {
  var response =  await getMisc("/resources.json");
  var resources = json.decode(response.body);
  return resources.map<HelpResource>(
    (resource) => new HelpResource.fromJson(resource)
  ).toList();
}

// lcs functions
