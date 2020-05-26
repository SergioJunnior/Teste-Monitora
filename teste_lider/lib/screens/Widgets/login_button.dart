import 'package:flutter/material.dart';
import 'package:teste_lider/bloc/login/button_state.dart';
import 'package:teste_lider/bloc/login/login_bloc.dart';

class LoginButton extends StatelessWidget {
  LoginButton(
    this.loginBloc,
  );
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      height: 50,
      child: StreamBuilder<ButtonState>(
          stream: loginBloc.outLoginButton,
          initialData: ButtonState(enabled: false, loading: false),
          builder: (context, snapshot) {
            return RaisedButton(
              color: Colors.green,
              disabledColor: Colors.green.withAlpha(150),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: snapshot.data.enabled
                  ? () => loginBloc.loginWithEmail()
                  : null,
              child: snapshot.data.loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          }),
    );
  }
}
