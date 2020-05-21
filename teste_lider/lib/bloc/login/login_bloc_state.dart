enum LoginState {
  IDLE,
  LOADING,
  LOADING_FACE,
  INVALID_CREDENTIAL,
  ERROR,
  EMAIL_NOT_CONFIRMED,
  DONE
}

class LoginBlocState {
  LoginBlocState(this.state, {this.errorMessage});

  LoginState state;
  String errorMessage;
}
