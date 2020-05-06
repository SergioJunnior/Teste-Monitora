import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teste_lider/bloc/signup_bloc.dart';
import 'package:teste_lider/models/model_user.dart';
import 'package:teste_lider/screens/SignUp/widgets/password_field.dart';
import 'package:teste_lider/screens/SignUp/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final _apelidoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  SignUpBloc _signUpBloc;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Cadastrar'),
        ),
        body: ScopedModelDescendant<User>(builder: (context, child, model) {
          return Form(
            key: _formkey,
            child: StreamBuilder<SignUpBlocState>(
                stream: _signUpBloc.outState,
                builder: (context, snapshot) {
                  return ListView(
                      padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        formField(
                          _apelidoController,
                          "Apelido",
                          _signUpBloc.setApelido,
                          (text) {
                            if (text.length < 6) return 'Apelido muito Curto';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          _nomeController,
                          "Nome",
                          _signUpBloc.setNome,
                          (text) {
                            if (text.length < 6) return 'Nome Inválido';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          _sobrenomeController,
                          "Sobrenome",
                          _signUpBloc.setSobrenome,
                          (text) {
                            if (text.length < 6) return 'Sobrenome Inválido';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          _emailController,
                          'E-mail',
                          _signUpBloc.setEmail,
                          (text) {
                            if (text.length < 6 ||
                                !text.contains(RegExp(
                                    r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")))
                              return 'Email Inválido';
                            return null;
                          },
                        ),
                        PasswordField(
                          controller: _passController,
                          onSaved: _signUpBloc.setPassword,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          height: 50,
                          child: RaisedButton(
                              color: Colors.green,
                              disabledColor: Colors.green.withAlpha(150),
                              child: snapshot.data.state == SignUpState.LOADING
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text('Cadastre-se',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              onPressed: () {
                                if (_formkey.currentState.validate()) {
                                  Map<String, dynamic> userData = {
                                    "apelido": _apelidoController.text,
                                    "nome": _nomeController.text,
                                    "sobrenome": _sobrenomeController.text,
                                    "email": _emailController.text,
                                  };

                                  model.signUp(
                                      userData: userData,
                                      pass: _passController.text,
                                      onSuccess: _onSuccess,
                                      onFail: _onFail);
                                }
                              }),
                        ),
                        Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Já tem uma conta?',
                                  style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Entrar',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        fontSize: 16,
                                      ))),
                            ],
                          ),
                        )
                      ]);
                }),
          );
        }));
  }

  void _onSuccess() {}

  void _onFail() {}
}

/*Widget buildTextFormField(String label, Function f,Function v) {

 
      return TextFormField(
       decoration: InputDecoration(
         labelText: label,
         border: OutlineInputBorder(),
       ),
       onSaved: f,
       validator: v,
  );
}*/
