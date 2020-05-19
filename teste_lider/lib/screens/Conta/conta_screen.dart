import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teste_lider/models/model_user.dart';
import 'package:teste_lider/screens/login_screen.dart';

class AccountScreen extends StatelessWidget {
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
                  TextField(
                    decoration: InputDecoration(labelText: ''),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 7)),
                  Text(
                    'Apelido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: ''),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 7)),
                  Text(
                    'Nome',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: ''),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 7)),
                  Text(
                    'Sobrenome',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.only(top: 7)),
                  TextField(
                    decoration: InputDecoration(labelText: ''),
                    enabled: false,
                  ),
                  Padding(padding: EdgeInsets.only(top: 7)),
                  Text(
                    'E-mail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
