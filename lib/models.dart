import 'package:http/http.dart' as http;
import 'dart:convert';

class LcsCredential {
  final String email;
  final String token;
  final DateTime expiration;

  LcsCredential(this.email, this.token, this.expiration);

  @override
  String toString() {
    return "LcsCredentail{email: ${this.email}, "
    + "token: ${this.token}, "
    + "expiration: ${this.expiration}}";
  }

  bool isExpired() {
    return this.expiration.isBefore(DateTime.now());
  }

  LcsCredential.fromJson(Map<String, dynamic> json)
  : email = json["email"],
    token = json["token"],
    expiration = DateTime.parse(json["valid_until"]);
}

class HelpResource {
  final String name;
  final String description;
  final String url;

  HelpResource(this.name, this.description, this.url);

  @override
  String toString() {
    return "HelpResource{name: ${this.name}, "
    + "description: ${this.description}, "
    + "url: ${this.url}}";
  }
  
  HelpResource.fromJson(Map<String, dynamic> json)
  : name = json["name"],
    description = json['desc'],
    url = json["url"];
}

class User {
  final String name;
  final String email;
  final Map<String, dynamic> role; // role.director, admin, organizer
  final Map<String, dynamic> dayOf; // this should always be a bool really
  
  User(this.name, this.email, this.dayOf, this.role);

  @override
  String toString() {
    return "User{name: ${this.name}, "
    + "email: ${this.email}, "
    + "role: ${this.role}, "
    + "dayOf: ${this.dayOf}";
  }

  // check if a hacker has already attended an event
  bool alreadyDid(String event) {
    if (!this.dayOf.containsKey(event)) {
      return false;
    } else {
      return this.dayOf[event];
    }
  }
  
  User.fromJson(Map<String, dynamic> json)
  : name = (json["first_name"] ?? "") + " " + (json["last_name"] ?? ""),
    email = json["email"],
    dayOf = json["day_of"],
    role = json["role"];
}

class LcsError implements Exception {
  String lcsError;
  int code;
  LcsError(http.Response res) {
    this.code = res.statusCode;
    if (res.statusCode >= 500) {
      this.lcsError = "internal error with lcs";
    } else {
      var body = jsonDecode(res.body);
      this.code = body["statusCode"];
      this.lcsError = body["body"];
    }
  }
  String errorMessage() => "LCS error $code: $lcsError";
  String toString() => errorMessage();
}

class LcsLoginFailed implements Exception {
  String errorMessage() => "bad username or password";
  String toString() => errorMessage();
}

class CredentialExpired implements Exception {
  String errorMessage() => "credential expired user must log in";
  String toString() => errorMessage();
}

class NoSuchUser implements Exception {
  String errorMessage() => "no user with that email";
  String toString() => errorMessage();
}

class PermissionError implements Exception {
  String errorMessage() => "you don't have permission to do that";
  String toString() => errorMessage();
}

class UpdateError implements Exception {
  final String lcsMessage;
  UpdateError(this.lcsMessage);
  String errorMessage() => "Failed to update user: $lcsMessage";
  String toString() => errorMessage();
}
