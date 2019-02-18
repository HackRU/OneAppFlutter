import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';
import 'dart:io' show Platform;

var env = Platform.environment;

void testHelpResources() async {
  var result = await helpResources();
  print("test helpResources");
  result.forEach((resource) {
      print(resource);
  });
}

void testSitemap() async {
  var result = await sitemap();
  print("test sitemap");
  print(result);
}

void testEvents() async {
  var result = await events();
  print("test events");
  print(result);
}

void testLabelUrl() async {
  var result = await labelUrl();
  print("test label-url");
  print(result);
}

void testExpired() {
  print("test catch expired credential");
  var l = LcsCredential("test", "account", DateTime.now());
  assert(l.isExpired());
}

void testLogin() async {
  try {
    await login("bogus", "login");
    print("failed to catch bad login");
  } on LcsLoginFailed catch (e) {
    print("caught failed login");
  }
  var l = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  assert(!l.isExpired());
}

void testPostLcsExpired() async {
  print("test for postLcs to catch expired credentials");
  var cred = LcsCredential("Bogus", "Cred", DateTime.now());
  try {
    await postLcs("/read", {}, cred);
    assert(false); // should have thrown CredentialExpired
  } on CredentialExpired catch(e) {
    print("succesfully caught expired credential");
  }
}

void testGetUser() async {
  var cred = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  var user = await getUser(cred);
  print("test get user");
  print(user);
}

void main() async {
  testHelpResources();
  testSitemap();
  testEvents();
  testLabelUrl();
  testExpired();
  testLogin();
  testPostLcsExpired();
  testGetUser();
}
