import 'dart:async';

import 'package:HackRU/models/models.dart';
import 'package:HackRU/services/hackru_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../auth/authentication.dart';
import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LcsCredential lcsCredential;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.lcsCredential,
    @required this.authenticationBloc,
  })  : assert(lcsCredential != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        print('===== username: ${event.username}, pass: ${event.password} =======');
        final cred = await login(event.username, event.password);
        print('===== from loginBloc: ${cred.token ?? ''}');
        if (cred.token != null) {
          authenticationBloc.add(LoggedIn(token: cred.token, email: cred.email));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: 'Error: Incorrect username or password!');
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
