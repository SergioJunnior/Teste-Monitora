import 'package:rxdart/rxdart.dart';
import 'package:teste_lider/models/model_user.dart';

enum SignUpState { IDLE, LOADING, ERROR }

class SignUpBlocState {
  SignUpBlocState(this.state, {this.errorMessage});

  SignUpState state;
  String errorMessage;
}

class SignUpBloc {
  final BehaviorSubject<SignUpBlocState> _stateController =
      BehaviorSubject<SignUpBlocState>.seeded(
          SignUpBlocState(SignUpState.IDLE));

  Stream<SignUpBlocState> get outState => _stateController.stream;

  User user = User();

  void setApelido(String apelido) {
    user.apelido = apelido;
  }

  void setNome(String nome) {
    user.nome = nome;
  }

  void setSobrenome(String sobrenome) {
    user.sobrenome = sobrenome;
  }

  void setEmail(String email) {
    user.email = email;
  }

  void setPassword(String password) {
    user.password = password;
  }

  void dispose() {
    _stateController.close();
  }
}
