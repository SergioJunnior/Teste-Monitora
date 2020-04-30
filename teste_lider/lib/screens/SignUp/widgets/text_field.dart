import 'package:flutter/material.dart';

class formField extends StatelessWidget {
  formField(this.label, this.saved, this.validator);

  final String label;
  final Function saved;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onSaved: saved,
      validator: validator,
    );
  }
}
