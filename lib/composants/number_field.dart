import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.formData,
    required this.field,
  });

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: field.name,
          labelStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.yellow[600]!, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow[600]!, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
          ),
        ),
        keyboardType: TextInputType.number,
        onSaved: (value) =>
            formData[field.name] = double.tryParse(value ?? '') ?? 0,
        validator: field.required
            ? (value) => value?.isEmpty == true ? 'Ce champ est requis' : null
            : null,
      ),
    );
  }
}
