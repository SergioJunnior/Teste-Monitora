import 'package:flutter/material.dart';

class formField extends StatelessWidget {
  formField(this.controler, this.label, this.saved, this.validator);

  final String label;
  final Function saved;
  final Function validator;
  final TextEditingController controler;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onSaved: saved,
      validator: validator,
    );
  }
}
