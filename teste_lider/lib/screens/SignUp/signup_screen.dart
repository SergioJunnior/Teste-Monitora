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
  // keys utilizadas
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  //controllers
  final _apelidoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  //intância do bloc do signUp
  SignUpBloc _signUpBloc;

  @override
  void initState() {
    super.initState();
    _signUpBloc = SignUpBloc();
  }

  @override
  void dispose() {
    _signUpBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Cadastrar'),
        ),
        body: ScopedModelDescendant<User>(builder: (
          context,
          child,
          model,
        ) {
          return Form(
            key: _formkey,
            child: StreamBuilder<SignUpBlocState>(
                stream: _signUpBloc.outState,
                builder: (context, snapshot) {
                  return ListView(
                      padding: const EdgeInsets.all(16),
                      children: <Widget>[
                        formField(
                          Icon(
                            Icons.alternate_email,
                            size: 20,
                          ),
                          _apelidoController,
                          "Apelido",
                          _signUpBloc.setApelido,
                          (text) {
                            if (text.length < 2) return 'Apelido muito Curto';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          Icon(Icons.mail_outline),
                          _nomeController,
                          "Nome",
                          _signUpBloc.setNome,
                          (text) {
                            if (text.length < 2) return 'Nome Inválido';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          Icon(Icons.mail_outline),
                          _sobrenomeController,
                          "Sobrenome",
                          _signUpBloc.setSobrenome,
                          (text) {
                            if (text.length < 4) return 'Sobrenome Inválido';
                            return null;
                          },
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                        formField(
                          Icon(Icons.mail_outline),
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
                              // onPressed que pega as inf dos controllers e realiza o cadastro do usuário
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

  //função caso ocorra erro na criação do usuário
  void _onSuccess() {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário Cadastrado com sucesso"),
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 3),
    ));
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pop();
    });
  }

  //função caso ocorra erro na criação do usuário
  void _onFail() {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
