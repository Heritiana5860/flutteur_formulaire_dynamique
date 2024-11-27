import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class DynamicForm {
  final String name;
  final List<DynamicFormField> fields;

  DynamicForm({
    required this.name,
    required this.fields,
  });
}
