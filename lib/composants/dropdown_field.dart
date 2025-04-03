import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class DropdownField extends StatefulWidget {
  const DropdownField({super.key, required this.formData, required this.field});

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.field.name,
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
        items: widget.field.options
            ?.map(
              (option) => DropdownMenuItem(
                value: option.toString(),
                child: Text(
                  option.toString(),
                ),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() {
          widget.formData[widget.field.name] = value;
        }),
        onSaved: (value) => widget.formData[widget.field.name] = value,
        validator: widget.field.required
            ? (value) => value == null ? 'Ce champ est requis' : null
            : null,
      ),
    );
  }
}
