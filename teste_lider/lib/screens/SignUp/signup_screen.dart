import 'package:flutter/material.dart';
import 'package:teste_lider/bloc/signup_bloc.dart';
import 'package:teste_lider/screens/SignUp/widgets/field_title.dart';
import 'package:teste_lider/screens/SignUp/widgets/password_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State < SignUpScreen > {

    final GlobalKey < FormState > _formkey = GlobalKey < FormState > ();

    SignUpBloc _signUpBloc;

    void _signUp() {
      if (_formkey.currentState.validate()) {
        _formkey.currentState.save();

        _signUpBloc.signUp();
      }
    }

    @override
    void initState() {
      super.initState();
      _signUpBloc = SignUpBloc();
    }

    @override
    void dispose() {
      _signUpBloc ?.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Cadastrar'),
        ),
        body: Form(
          key: _formkey,
          child: StreamBuilder < SignUpBlocState > (
            stream: _signUpBloc.outState,
            builder: (context, snapshote) {
              
              return ListView(
                padding: const EdgeInsets.all(16),
                  children: < Widget > [
                    const FieldTitle(
                        title: "Apelido",
                        subtitle: "(Como aparecerá em seus anúncios.)",
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Exemplo: João S."
                          ),
                          validator: (text) {
                            if (text.length < 6)
                              return 'Apelido muito Curto';
                            return null;
                          },
                          onSaved: _signUpBloc.setApelido,
                      ),
                      const SizedBox(height: 8),
                        const FieldTitle(
                            title: "Nome",
                            subtitle: "",
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onSaved: _signUpBloc.setNome,
                          ),
                          const SizedBox(height: 8),
                            const FieldTitle(
                                title: "Sobrenome",
                                subtitle: "",
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: _signUpBloc.setSobrenome,
                              ),
                              const SizedBox(height: 8),
                                const FieldTitle(
                                    title: "E-mail",
                                    subtitle: "(Enviaremos um e-mail para confirmação.)",
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (text) {
                                        if (text.length < 6 || !text.contains(RegExp(r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")))
                                          return 'Email Inválido';
                                        return null;

                                      },
                                      onSaved: _signUpBloc.setEmail,
                                  ),
                                  const SizedBox(height: 8),
                                    const FieldTitle(
                                        title: "Senha",
                                        subtitle: "(Use letra,números e caracteres especiais.)",
                                      ),
                                      PasswordField(
                                        onSaved: _signUpBloc.setPassword,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 24),
                                          height: 50,
                                          child: RaisedButton(
                                            color: Colors.green,
                                            disabledColor: Colors.green.withAlpha(150),
                                            child: Text(
                                              'Cadastre-se',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              )
                                            ),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            onPressed: _signUp,


                                          ),
                                      )
                  ]
              );
            }
            ),
          ));
        }
      }