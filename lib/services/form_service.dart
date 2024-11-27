import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/models/dynamic_form.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';
import 'package:http/http.dart' as http;

class DynamicFormService {
  Future<List<DynamicForm>> fetchForms() async {
    final uri = Uri.parse('http://10.85.5.165:8000/api/forms/');
    try {
      final response = await http.get(uri);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> formsJson = json.decode(response.body);

        return formsJson
            .map((formJson) => DynamicForm(
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
