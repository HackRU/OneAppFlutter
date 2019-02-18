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
  final Map<String, dynamic> dayOf; // this should always be a bool really
  
  User(this.name, this.email, this.dayOf);

  @override
  String toString() {
    return "User{name: ${this.name}, "
    + "email: ${this.email}, "
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
    dayOf = json["day_of"];
}

class LcsError implements Exception {
  String errorMessage() => "There was an issue trying to use lcs";
}

class LcsLoginFailed implements Exception {
  String errorMessage() => "bad username or password";
}

class CredentialExpired implements Exception {
  String errorMessage() => "credential expired user must log in";
}
