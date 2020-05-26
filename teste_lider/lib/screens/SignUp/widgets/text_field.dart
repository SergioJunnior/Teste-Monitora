import 'package:flutter/material.dart';

class formField extends StatelessWidget {
  formField(this.icon, this.controler, this.label, this.saved, this.validator);

  final Icon icon;
  final String label;
  final Function saved;
  final Function validator;
  final TextEditingController controler;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onSaved: saved,
      validator: validator,
    );
  }
}
