import 'package:HackRU/hackru_service.dart';
import 'package:HackRU/models.dart';
import 'dart:io' show Platform;

var env = Platform.environment;

void testHelpResources() async {
  var result = await helpResources();
  print("************* testHelpResources **********");
  result.forEach((resource) {
      print(resource);
  });
}

void testSitemap() async {
  var result = await sitemap();
  print("************* testSitemap **********");
  print(result);
}

void testEvents() async {
  var result = await events();
  print("************* testEvents **********");
  print(result);
}

void testLabelUrl() async {
  var result = await labelUrl();
  print("************* testLabelUrl **********");
  print(result);
}

void testExpired() {
  print("************* testExpired cred **********");
  var l = LcsCredential("test", "account", DateTime.now());
  assert(l.isExpired());
}

void testLogin() async {
  try {
    await login("bogus", "login");
    print("************* failed to catch bad login *************");
  } on LcsLoginFailed catch (e) {
    print("************* caught failed login *************");
  }
  var l = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  assert(!l.isExpired());
}

void testPostLcsExpired() async {
  var cred = LcsCredential("Bogus", "Cred", DateTime.now());
  try {
    await postLcs("/read", {}, cred);
    assert(false); // should have thrown CredentialExpired
  } on CredentialExpired catch(e) {
    print(" ************* succesfully caught expired credential *************");
  }
}

void testGetUser() async {
  var cred = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  var user = await getUser(cred);
  print("************* test get user *************");
  print(user);
}
void testOtherUser() async {
  var cred = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  var user = await getUser(cred, env["LCS_USER2"]);
  try {
    var baduser = await getUser(cred, "fail@email.com");
    assert(false);
  } on NoSuchUser catch(error) {
    print("************* successfuly caught attempt to get nonexistent user *************");
  }
  print("************* test get a different user *************");
  print(user);
}

void testUpdateDayOf() async {
  var cred = await login(env["LCS_USER"], env["LCS_PASSWORD"]);
  var user = await getUser(cred, env["LCS_USER2"]);
  await updateUserDayOf(cred, user, "fake_event${DateTime.now().millisecondsSinceEpoch}");
  var user2 = await getUser(cred, env["LCS_USER2"]);
  print("************* test update user day_of *************");
  print(user);
  print(user2);
}
/*
// !%$#@*&!!!!
void testUpdateDayOfPerm() async {
  var cred = await login(env["LCS_USER2"], env["LCS_PASSWORD2"]);
  var user = await getUser(cred, "LCS_USER");
  await updateUserDayOf(cred, user, "fake_event${DateTime.now().millisecondsSinceEpoch}");
  var user2 = await getUser(cred, "LCS_USER");
  print("************* test update user day_of *************");
  print(user);
  print(user2);
}*/

void main() async {
  testHelpResources();
  testSitemap();
  testEvents();
  testLabelUrl();
  testExpired();
  testLogin();
  testPostLcsExpired();
  testGetUser();
  testOtherUser();
  testUpdateDayOf();

}
