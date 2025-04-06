import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class DynamicForm {
  final int? id;
  final String name;
  final List<DynamicFormField> fields;

  DynamicForm({
    this.id,
    required this.name,
    required this.fields,
  });
}
