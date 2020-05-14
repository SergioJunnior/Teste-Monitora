import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
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

  Future<bool> loginWithEmail() async {
    final email = _emailController.value;
    final password = _passwordController.value;

    ScopedModelDescendant<User>(builder: (context, child, model) {
      model.signIn(
        email: email,
        password: password,
      );
    });
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
}
