import 'package:flutter/material.dart';
import 'package:teste_lider/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Lider',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}