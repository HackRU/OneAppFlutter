///=======================================
///          EXCEPTION HANDLERS
///=======================================

class LcsLoginFailed implements Exception {
  String errorMessage() => "Incorrect Username or Password!";
  String toString() => errorMessage();
}

class CredentialExpired implements Exception {
  String errorMessage() => "credential expired user must log in";
  String toString() => errorMessage();
}

class NoSuchUser implements Exception {
  String errorMessage() => "No user with that email";
  String toString() => errorMessage();
}

class PermissionError implements Exception {
  String errorMessage() => "Unauthorized User / Bad Role";
  String toString() => errorMessage();
}

class UpdateError implements Exception {
  final String lcsMessage;
  UpdateError(this.lcsMessage);
  String errorMessage() => "Failed to update user: $lcsMessage";
  String toString() => errorMessage();
}

class LabelPrintingError implements Exception {
  String errorMessage() => "Error printing label!";
  String toString() => errorMessage();
}

class UserNotFound implements Exception {
  String errorMessage() => "User not found!";
  String toString() => errorMessage();
}

class UserCheckedEvent implements Exception {
  String errorMessage() => "User checked into event!";
  String toString() => errorMessage();
}