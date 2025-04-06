import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/checkbox_field.dart';
import 'package:formulaire_dynamique/composants/checkboxgroup_field.dart';
import 'package:formulaire_dynamique/composants/date_field.dart';
import 'package:formulaire_dynamique/composants/dropdown_field.dart';
import 'package:formulaire_dynamique/composants/number_field.dart';
import 'package:formulaire_dynamique/composants/select_file.dart';
import 'package:formulaire_dynamique/composants/slider_field.dart';
import 'package:formulaire_dynamique/composants/textarea_field.dart';
import 'package:formulaire_dynamique/composants/textfield.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/db_helper/database_helper.dart';
import 'package:formulaire_dynamique/models/dynamic_form.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';
import 'package:formulaire_dynamique/models/form_submission.dart';

class DynamicFormScreen extends StatefulWidget {
  final DynamicForm form;

  const DynamicFormScreen({super.key, required this.form});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isSubmitting = false;

  Widget _buildFormField(DynamicFormField field) {
    switch (field.type) {
      case 'file':
        return SelectFile(formData: formData, field: field);

      case 'text':
        return DynamicField(formData: formData, field: field);

      case 'number':
        return NumberField(formData: formData, field: field);

      case 'dropdown':
      case 'select':
        return DropdownField(formData: formData, field: field);

      case 'checkbox':
        // Initialiser la valeur si elle n'existe pas
        formData[field.name] = formData[field.name] ?? false;

        return CheckboxField(formData: formData, field: field);

      case 'checkboxgroup':
        // Initialiser la valeur si elle n'existe pas
        formData[field.name] = formData[field.name] ?? <String>[];

        return CheckboxgroupField(formData: formData, field: field);

      case 'date':
        return DateFields(formData: formData, field: field);

      case 'textarea':
        return TextareaField(formData: formData, field: field);

      case 'slider':
        // Initialiser la valeur par défaut
        double min = field.min ?? 0.0;
        double max = field.max ?? 10.0;
        double step = field.step ?? 1.0;
        formData[field.name] = formData[field.name] ?? min;

        return SliderField(
            formData: formData, field: field, max: max, min: min, step: step);

      default:
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey[200],
            ),
            child: MyText(text: "Type de champ non supporté: ${field.type}"),
          ),
        );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create form submission
        final submission = FormSubmission(
          formId: widget.form.id ?? 0,
          data: formData,
          submittedAt: DateTime.now(),
        );

        // 1. Save to local SQLite database
        final id = await _dbHelper.insertFormSubmission(submission);
        debugPrint(
            "Données du formulaire sauvegardées localement avec ID: $id");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formulaire sauvegardé localement'),
            duration: Duration(seconds: 3),
          ),
        );

        // Reset form after successful submission if needed
        setState(() {
          formData = {};
        });

        Navigator.pop(context);
      } catch (e) {
        debugPrint("Erreur lors de la sauvegarde: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la sauvegarde du formulaire'),
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: widget.form.name),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...widget.form.fields.map(_buildFormField),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isSubmitting ? null : _submitForm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                    color: _isSubmitting ? Colors.grey : Colors.green.shade700,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.yellow[600]!, width: 1.5)),
                child: Center(
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const MyText(
                          text: "Sauvegarder",
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
