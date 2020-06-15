import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teste_lider/bloc/login/login_bloc.dart';
import 'package:teste_lider/screens/Conta/Widgets/text_fields.dart';
import 'package:teste_lider/screens/login_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen(LoginBloc loginBloc);

  @override
  AccountScreenState createState() => AccountScreenState(LoginBloc());
}

class AccountScreenState extends State<AccountScreen> {
  //instancia criada para usar o blo do login nessa tela
  AccountScreenState(this.loginBloc);
  final LoginBloc loginBloc;

  //Variavel que recebe o Id do usuário
  String userId;

  //Futuro que pega e retorna o valor do UID do banco de dados
  Future getUserId() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Barra do topo da tela minha conta com um action button de sair
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Minha Conta',
          ),
          backgroundColor: Colors.green,
          // widget que recebe o botão Sair
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
        // corpo da tela minha contaa com um ScrollView
        body: SingleChildScrollView(
            // FutureBuilder que espera o UID do banco e carrega a tela
            child: new FutureBuilder(
                future: getUserId(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return StreamBuilder(
                      initialData: [],
                      // carrega os dados do banco em snapshots
                      stream: Firestore.instance
                          .collection('users')
                          .document(userId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // variavel que contem contem os dados do banco de dados
                        var dados = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(150)),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                FieldText(
                                    Icon(Icons.alternate_email,
                                        size: 20, color: Colors.green),
                                    '${dados['apelido']}'),
                                Padding(padding: EdgeInsets.only(top: 25)),
                                Text(
                                  'Nome',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                FieldText(
                                    Icon(
                                      Icons.person_outline,
                                      color: Colors.green,
                                    ),
                                    '${dados['nome']}'),
                                Padding(padding: EdgeInsets.only(top: 25)),
                                Text(
                                  'Sobrenome',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                FieldText(
                                    Icon(
                                      Icons.person_outline,
                                      color: Colors.green,
                                    ),
                                    '${dados['sobrenome']}'),
                                Padding(padding: EdgeInsets.only(top: 25)),
                                Text(
                                  'E-mail',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                FieldText(
                                    Icon(
                                      Icons.mail_outline,
                                      color: Colors.green,
                                    ),
                                    '${dados['email']}'),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }
                })));
  }
}
