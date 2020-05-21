import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teste_lider/bloc/login/login_bloc.dart';
import 'package:teste_lider/models/model_user.dart';
import 'package:teste_lider/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen(this.loginBloc);
  final LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Minha Conta',
          ),
          backgroundColor: Colors.green,
          actions: <Widget>[
            FlatButton(
              child: Text('Sair'),
              textColor: Colors.white,
              onPressed: () {
                model.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(color: Colors.green.withAlpha(150)),
                alignment: Alignment.center,
                child: Text(
                  'Dados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 7)),
                  Text(
                    'Apelido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                      decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    labelText: '${loginBloc.userData['apelido']}',
                    enabled: false,
                  )),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Text(
                    'Nome',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        labelText: '${loginBloc.userData['nome']}'),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Text(
                    'Sobrenome',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        ),
                        labelText: '${loginBloc.userData['sobrenome']}'),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Text(
                    'E-mail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.green,
                        ),
                        labelText: '${loginBloc.userData['email']}'),
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
