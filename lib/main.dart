import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/views/dynamic_forms_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'formulaire dynamique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const DynamicFormsPage(),
    );
  }
}