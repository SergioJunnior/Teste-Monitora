import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:teste_lider/models/model_user.dart';
import 'package:teste_lider/screens/Conta/conta_screen.dart';
import 'package:teste_lider/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
      model: User(),
      child: MaterialApp(
        title: 'Teste Lider',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
