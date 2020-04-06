import 'dart:async';

import 'package:HackRU/models/cred_manager.dart';
import 'package:HackRU/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'authentication.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LcsCredential lcsCredential;

  AuthenticationBloc({@required this.lcsCredential}) : assert(lcsCredential != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await hasCredentials();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await persistCredentials(event.token, event.email);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await deleteCredentials();
      yield AuthenticationUnauthenticated();
    }
  }
}
