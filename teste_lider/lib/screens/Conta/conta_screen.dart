import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_lider/bloc/login/login_bloc.dart';
import 'package:teste_lider/screens/login_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen(LoginBloc loginBloc);

  @override
  AccountScreenState createState() => AccountScreenState(LoginBloc());
}

class AccountScreenState extends State<AccountScreen> {
  AccountScreenState(this.loginBloc);
  final LoginBloc loginBloc;

  String userId;

  void getUserId() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
  }

  @override
  Widget build(BuildContext context) {
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
                loginBloc.signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: new StreamBuilder(
            initialData: [],
            stream: Firestore.instance
                .collection('users')
                .document(userId)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return new Text('Loading');
              }
              var dados = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 100,
                    decoration:
                        BoxDecoration(color: Colors.green.withAlpha(150)),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextField(
                          decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          size: 20.0,
                          color: Colors.green,
                        ),
                        labelText: '${dados('apelido')}',
                        enabled: false,
                      )),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      Text(
                        'Nome',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.green,
                            ),
                            labelText: '${dados['nome']}'),
                        enabled: false,
                      ),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      Text(
                        'Sobrenome',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.green,
                            ),
                            labelText: '${dados['sobrenome']}'),
                        enabled: false,
                      ),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      Text(
                        'E-mail',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: Colors.green,
                            ),
                            labelText: '${dados['email']}'),
                        enabled: false,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ));
  }
}
