import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form.dart';
import 'package:formulaire_dynamique/services/form_service.dart';
import 'package:formulaire_dynamique/views/dynamic_form_screen.dart';

class DynamicFormsPage extends StatefulWidget {
  const DynamicFormsPage({super.key});

  @override
  _DynamicFormsPageState createState() => _DynamicFormsPageState();
}

class _DynamicFormsPageState extends State<DynamicFormsPage> {
  late Future<List<DynamicForm>> _forms;

  @override
  void initState() {
    super.initState();
    _forms = DynamicFormService().fetchForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(text: 'Formulaires Dynamiques'),
        centerTitle: true,
        elevation: 1,
      ),
      body: FutureBuilder<List<DynamicForm>>(
        future: _forms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("${snapshot.hasError}");
            return const Center(child: Text('Erreur de chargement'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              var form = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  dense: true,
                  tileColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  leading: CircleAvatar(
                    child: MyText(text: form.name[0]),
                  ),
                  title: MyText(
                    text: form.name,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    ),
                    trailing: const Icon(Icons.navigate_next),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DynamicFormScreen(form: form))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
