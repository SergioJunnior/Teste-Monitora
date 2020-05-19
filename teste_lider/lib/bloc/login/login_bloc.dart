import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teste_lider/Validators/login_validator.dart';
import 'package:teste_lider/bloc/login/button_state.dart';
import 'package:teste_lider/bloc/login/field_statebloc.dart';
import 'package:teste_lider/bloc/login/login_bloc_state.dart';
import 'package:teste_lider/models/model_user.dart';

class LoginBloc with LoginValidator {
  FirebaseUser firebaseUser;
  User user;
  final BehaviorSubject<LoginBlocState> _stateController =
      BehaviorSubject<LoginBlocState>.seeded(LoginBlocState(LoginState.IDLE));
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user != null) {
      } else {
        _stateController.add(LoginBlocState(LoginState.IDLE));
      }
    });
  }

  Stream<LoginBlocState> get outState => _stateController.stream;
  Stream<FieldState> get outEmail => Rx.combineLatest2(
          _emailController.stream.transform(emailValidator), outState, (a, b) {
        a.enabled = b.state != LoginState.LOADING;
        return a;
      });
  Stream<FieldState> get outPassword => Rx.combineLatest2(
          _passwordController.stream.transform(passwordValidator), outState,
          (a, b) {
        a.enabled = b.state != LoginState.LOADING;
        return a;
      });
  Stream<ButtonState> get outLoginButton =>
      Rx.combineLatest3(outEmail, outPassword, outState, (a, b, c) {
        return ButtonState(
            loading: c.state == LoginState.LOADING,
            enabled: a.error == null &&
                b.error == null &&
                c.state != LoginState.LOADING);
      });

  void signIn({
    String email,
    String password,
    VoidCallback onSuccess,
    VoidCallback onFail,
  }) async {
    _stateController.add(LoginBlocState(LoginState.LOADING));
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      firebaseUser = authResult.user;
      onSuccess();
      return firebaseUser.uid;
    }).catchError((e) {
      onFail();
    });
  }

  loginWithEmail() {
    final email = _emailController.value;
    final password = _passwordController.value;
    signIn(
      email: email,
      password: password,
      onSuccess: onSuccess(),
      onFail: onFail(),
    );
  }

  Future<bool> loginWithFacebook() async {
    _stateController.add(LoginBlocState(LoginState.LOADING_FACE));

    await Future.delayed(Duration(seconds: 2));

    _stateController.add(LoginBlocState(LoginState.DONE));
    return true;
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

  onSuccess() {
    _stateController.add(LoginBlocState(LoginState.DONE));
    Future.delayed(Duration(seconds: 3)).then((_) {});
  }

  onFail() {}
}
