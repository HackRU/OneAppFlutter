import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String email;
  const LoggedIn({@required this.token, this.email});

  @override
  List<Object> get props => [token, email];

  @override
  String toString() => 'LoggedIn { token: $token, email: $email }\n';
}

class LoggedOut extends AuthenticationEvent {}
