import 'package:flutter/material.dart';
import 'package:teste_lider/screens/SignUp/widgets/field_title.dart';
import 'package:teste_lider/screens/SignUp/widgets/password_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State < SignUpScreen > {

  final GlobalKey < FormState > _formkey = GlobalKey < FormState > ();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Cadastrar'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              validator: (text){
                if(text.length <6)
                  return 'Apelido muito Curto';
                  return null;
              },
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
              validator: (text){
                if(text.length <6 || !text.contains(RegExp(r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$")))
                return 'Email Inválido';
                return null;

              },
              onSaved: (text){

              },
              ),
              const SizedBox(height: 8),
              const FieldTitle(
                  title: "Senha",
                  subtitle: "(Use letra,números e caracteres especiais.)",
              ),
              PasswordField(
                onSaved: (text){

                },
              ),
              
            ]
        ),
      ),
    );
  }
}