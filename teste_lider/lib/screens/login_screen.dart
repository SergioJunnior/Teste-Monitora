import 'package:flutter/material.dart';
import 'package:teste_lider/bloc/login/field_statebloc.dart';
import 'package:teste_lider/bloc/login/login_bloc.dart';
import 'package:teste_lider/screens/SignUp/signup_screen.dart';
import 'package:teste_lider/screens/Widgets/facebook_button.dart';
import 'package:teste_lider/screens/Widgets/login_button.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State < LoginScreen > {

  LoginBloc _loginBloc = LoginBloc();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: < Widget > [
              ClipRRect(
                child: Container(
                  padding: EdgeInsets.only(top: 75, bottom: 50, ),
                  child: Image.asset(
                    'images/logo.jpg',
                    height: 150,
                  ),
                )
              ),
              StreamBuilder < FieldState > (
                stream: _loginBloc.outEmail,
                initialData: FieldState(),
                builder: (context, snapshot) {
                  return Container(
                  height: 40,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                       errorText: snapshot.data.error,
                    ),
                    onChanged: _loginBloc.changeEmail,
                    enabled: snapshot.data.enabled,
                  ),);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 180, bottom: 4, top: 14),
                  child: Row(
                    children: < Widget > [
                      GestureDetector(
                        child: Text(
                          "Esqueceu sua senha?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )
                        ),
                        onTap: () {
                          //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> RecoveryScreen()));
                        },
                      )
                    ]
                  ),
              ),
              StreamBuilder < FieldState > (
                stream: _loginBloc.outPassword,
                initialData: FieldState(),
                builder: (context, snapshot) {
                  return Container(
                    height: 40,
                   child: TextField(
                    autocorrect: false,
                    obscureText: true,

                    decoration: InputDecoration(
                      labelText: "Senha",
                      border: const OutlineInputBorder(),
                        errorText: snapshot.data.error,
                    ),
                    onChanged: _loginBloc.changePassword,
                    enabled: snapshot.data.enabled,
                  ),
                );
                }),
              LoginButton(_loginBloc),
              FacebookButton(_loginBloc),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: < Widget > [
                      const Text(
                          "Não tem uma conta ?",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUpScreen()));
                          },
                          child: Text(
                            "Cadastre-se",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 16,
                            )
                          ),
                        )
                    ],
                  ),
              )
            ],
          ), ),
      ),
    );
  }
}