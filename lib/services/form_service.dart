import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formulaire_dynamique/models/dynamic_form.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';
import 'package:http/http.dart' as http;

class DynamicFormService {
  Future<List<DynamicForm>> fetchForms() async {
    final uri = Uri.parse(dotenv.env['URL']!);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> formsJson = json.decode(response.body);

        return formsJson
            .map((formJson) => DynamicForm(
                id: formJson['id'],
                name: formJson['name'],
                fields: (formJson['fields'] as List)
                    .map((fieldJson) => DynamicFormField(
                        name: fieldJson['name'],
                        type: fieldJson['type'],
                        required: fieldJson['required'] ?? false,
                        options: fieldJson['options']))
                    .toList()))
            .toList();
      } else {
        throw Exception('Impossible de charger les formulaires');
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des formulaires : $e");
      return [];
    }
  }
}
