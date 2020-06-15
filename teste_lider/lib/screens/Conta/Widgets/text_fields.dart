import 'package:flutter/material.dart';

//widget utilizado para montar as config dos TextField da tela minha conta
class FieldText extends StatelessWidget {
  FieldText(
    this.icon,
    this.label,
  );

  final Icon icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: label,
      ),
      enabled: false,
    );
  }
}
