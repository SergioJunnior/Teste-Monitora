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
  // variaveis do bloc
  FirebaseUser firebaseUser;
  User user;
  String erro;

  // controlador de fluxo que é atualizado com as info a todo momento
  final BehaviorSubject<LoginBlocState> _stateController =
      BehaviorSubject<LoginBlocState>.seeded(LoginBlocState(LoginState.IDLE));
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // getters do sistema
  String get getError => erro;
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
  // getter com regra RX
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

  // Stream que intancia os eventos do state
  @override
  Stream<LoginState> mapEventToState(LoginState event) async* {
    yield event;
  }

  // Função com regras de login
  void signIn({
    String email,
    String password,
    VoidCallback onSuccess,
    Function onFail,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      firebaseUser = authResult.user;
      onSuccess();
      return firebaseUser.uid;
    }).catchError((erro) {
      print('Entrou no erro');
      onFail(erro.code);
    });
  }

  // função de login
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

  // função de LogOut
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    firebaseUser = null;
  }

  // future que verifica se o usuário está logado e retorna o user
  Future<bool> isSignedIn() async {
    final currentUser = (await FirebaseAuth.instance.currentUser()).uid;
    return currentUser != null;
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }

  // metodo chamado caso ocorra sucesso no login
  onSuccess() {
    Future.delayed(Duration(seconds: 3)).then((_) {});
    add(LoginState.DONE);
  }

  // metodo chamado caso ocorra erro no login
  onFail(String errorMessage) {
    // switch que verifica o erro e indica qual mensagem a variavel receberá
    switch (errorMessage) {
      case ErrorCodes.ERROR_C0DE_NETWORK_ERROR:
        erro = "Sem Conexão Ativa";
        break;
      case ErrorCodes.ERROR_USER_NOT_FOUND:
        erro = "Usuarío não encontrado";
        break;
      case ErrorCodes.ERROR_INVALID_EMAIL:
        erro = "Email invalido";
        break;
      case ErrorCodes.ERROR_WRONG_PASSWORD:
        erro = "Senha está errada!";
        break;
    }
    add(LoginState.ERROR);
  }
}
