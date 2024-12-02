import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class DynamicFormScreen extends StatefulWidget {
  final DynamicForm form;

  const DynamicFormScreen({super.key, required this.form});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  Widget _buildFormField(DynamicFormField field) {
    switch (field.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            decoration: InputDecoration(
                labelText: field.name,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                )),
            onSaved: (value) => formData[field.name] = value,
            validator: field.required
                ? (value) =>
                    value?.isEmpty == true ? 'Ce champ est requis' : null
                : null,
          ),
        );
      case 'dropdown':
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: field.name,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            items: field.options
                ?.map(
                  (option) => DropdownMenuItem(
                    value: option.toString(),
                    child: Text(
                      option.toString(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => formData[field.name] = value,
            validator: field.required
                ? (value) => value == null ? 'Ce champ est requis' : null
                : null,
          ),
        );
      default:
        return Container();
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      print(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: widget.form.name),
        centerTitle: true,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...widget.form.fields.map(_buildFormField),
            GestureDetector(
              onTap: _submitForm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: MyText(
                    text: "Sauvegarder",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
