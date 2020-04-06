import 'dart:convert';
import 'package:http/http.dart' as http;

/// LCS Credential
///
/// @param email user's email address
/// @param token authentication token
/// @param time auth token expire time

class LcsCredential {
  final String email;
  final String token;
  final DateTime expiration;

  LcsCredential(this.email, this.token, this.expiration);

  /// returns JSON string
  String jsonString() {
    var exp = this.expiration.toIso8601String();
    return '{"email": "${this.email}", ' +
        '"token": "${this.token}", ' +
        '"valid_until": "$exp"}';
  }

  @override
  String toString() {
    return "LcsCredential{email: ${this.email}, " +
        "token: ${this.token}, " +
        "expiration: ${this.expiration}}";
  }

  /// Verify if auth token is expired or not
  bool isExpired() {
    return this.expiration.isBefore(DateTime.now());
  }

  LcsCredential.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        token = json["token"],
        expiration = DateTime.parse(json["valid_until"]);
}

/// Help Page Resource
///
/// @param name resource name
/// @param description resource description
/// @param url resource url

class HelpResource {
  final String name;
  final String description;
  final String url;

  HelpResource(this.name, this.description, this.url);

  @override
  String toString() {
    return "HelpResource{name: ${this.name}, " +
        "description: ${this.description}, " +
        "url: ${this.url}}";
  }

  HelpResource.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        description = json['desc'],
        url = json["url"];
}

/// Announcement Resource
///
/// @param text announcement description
/// @param ts time stamp when an announcement was made

class Announcement {
  final String text;
  final String ts;

  Announcement({this.text, this.ts});

  @override
  String toString() {
    return '{"text": ${json.encode(this.text)}' +
        ',"ts": ${json.encode(this.ts)}}';
  }

  Announcement.fromJson(Map<String, dynamic> json)
      : text = json["text"],
        ts = json['ts'];
}

/// Day-Of Event Resource
///
/// @param summary event name
/// @param location event location which can be used to fetch event map
/// @param start event time

class Event {
  final String summary;
  final String location;
  final DateTime start;

  Event({this.summary, this.location, this.start});

  @override
  String toString() {
    return "{name: ${this.summary}, " +
        "location: ${this.location}, " +
        "time: ${this.start} }";
  }

  Event.fromJson(Map<String, dynamic> json)
      : summary = json['summary'],
        location = json['location'],
        start = DateTime.parse(json['start']['dateTime']);
}

/// User Profile
///
/// @param name user name
/// @param email user email address
/// @param status user status (accepted, not accepted, coming, etc)
/// @param role user role (director, admin, organizer)
/// @param dayof user data (whether scanned for an event or not)

class User {
  final String name;
  final String email;
  final String status;
  final Map<String, dynamic> role;
  final Map<String, dynamic> dayOf;

  User(this.name, this.email, this.dayOf, this.role, this.status);

  @override
  String toString() {
    return "User{name: ${this.name}, " +
        "email: ${this.email}, " +
        "status: ${this.status}, " +
        "role: ${this.role}, " +
        "dayOf: ${this.dayOf}";
  }

  /// check if a hacker has already attended an event
  bool alreadyDid(String event) {
    if (!this.dayOf.containsKey(event)) {
      return false;
    } else {
      return this.dayOf[event];
    }
  }

  bool isDelayedEntry() {
    return this.status == "waitlist";
  }

  User.fromJson(Map<String, dynamic> json)
      : name = (json["first_name"] ?? "") + " " + (json["last_name"] ?? ""),
        email = json["email"],
        dayOf = json["day_of"],
        status = json["registration_status"],
        role = json["role"];
}

/// LCS Error
///
/// @param error handle lcs errors

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
