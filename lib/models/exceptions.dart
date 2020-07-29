///=======================================
///          EXCEPTION HANDLERS
///=======================================

class LcsLoginFailed implements Exception {
  String errorMessage() => 'Incorrect Username or Password!';
  @override
  String toString() => errorMessage();
}

class CredentialExpired implements Exception {
  String errorMessage() => 'credential expired user must log in';
  @override
  String toString() => errorMessage();
}

class NoSuchUser implements Exception {
  String errorMessage() => 'No user with that email';
  @override
  String toString() => errorMessage();
}

class PermissionError implements Exception {
  String errorMessage() => 'Unauthorized User / Bad Role';
  @override
  String toString() => errorMessage();
}

class UpdateError implements Exception {
  final String lcsMessage;
  UpdateError(this.lcsMessage);
  String errorMessage() => 'Failed to update user: $lcsMessage';
  @override
  String toString() => errorMessage();
}

class LabelPrintingError implements Exception {
  String errorMessage() => 'Error printing label!';
  @override
  String toString() => errorMessage();
}

class UserNotFound implements Exception {
  String errorMessage() => 'User not found!';
  @override
  String toString() => errorMessage();
}

class UserCheckedEvent implements Exception {
  String errorMessage() => 'User checked into event!';
  @override
  String toString() => errorMessage();
}
