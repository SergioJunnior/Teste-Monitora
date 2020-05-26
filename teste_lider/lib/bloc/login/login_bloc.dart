import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:teste_lider/Validators/login_validator.dart';
import 'package:teste_lider/bloc/login/button_state.dart';
import 'package:teste_lider/bloc/login/field_statebloc.dart';
import 'package:teste_lider/bloc/login/login_bloc_state.dart';
import 'package:teste_lider/models/model_user.dart';
import 'package:bloc/bloc.dart';
import 'package:teste_lider/utils/error_codes.dart';

class LoginBloc extends Bloc<LoginState, LoginState> with LoginValidator {
  FirebaseUser firebaseUser;
  User user;
  Map<String, dynamic> userData = Map();
  static String error = error;

  final BehaviorSubject<LoginBlocState> _stateController =
      BehaviorSubject<LoginBlocState>.seeded(LoginBlocState(LoginState.IDLE));
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  String get getError => error;
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
  @override
  LoginState get initialState => LoginState.IDLE;

  @override
  Stream<LoginState> mapEventToState(LoginState event) async* {
    yield event;
  }

  void signIn({
    String email,
    String password,
    VoidCallback onSuccess,
    VoidCallback onFail,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      firebaseUser = authResult.user;
      onSuccess();
      loadUserData();
      return firebaseUser.uid;
    }).catchError((error) {
      onFail();
    });
  }

  Future<Null> loadUserData() async {
    DocumentSnapshot docUser = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();
    userData = docUser.data;
  }

  void loginWithEmail() async {
    final email = _emailController.value;
    final password = _passwordController.value;
    if (email == null || password == null) {
      add(LoginState.INVALID_CREDENTIAL);
      return;
    }
    add(LoginState.LOADING);
    signIn(
      email: email,
      password: password,
      onSuccess: onSuccess,
      onFail: onFail,
    );
  }

  Future<bool> loginWithFacebook() async {
    _stateController.add(LoginBlocState(LoginState.LOADING_FACE));

    await Future.delayed(Duration(seconds: 2));

    _stateController.add(LoginBlocState(LoginState.DONE));
    return true;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (FirebaseAuth.instance.currentUser().toString());
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

  onSuccess() {
    Future.delayed(Duration(seconds: 3)).then((_) {});
    _stateController.add(LoginBlocState(LoginState.DONE));
  }

  onFail() {
    switch (error) {
      case ErrorCodes.ERROR_C0DE_NETWORK_ERROR:
        error = ErrorMessages.ERROR_C0DE_NETWORK_ERROR;
        break;

      case ErrorCodes.ERROR_USER_NOT_FOUND:
        error = ErrorMessages.ERROR_USER_NOT_FOUND;
        break;

      case ErrorCodes.ERROR_INVALID_EMAIL:
        error = ErrorMessages.ERROR_INVALID_EMAIL;
        break;

      case ErrorCodes.ERROR_WRONG_PASSWORD:
        error = ErrorMessages.ERROR_WRONG_PASSWORD;
        break;
    }
    return error;
  }
}
