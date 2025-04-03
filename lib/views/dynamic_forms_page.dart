import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/services/form_service.dart';
import 'package:formulaire_dynamique/views/dynamic_form_screen.dart';

class DynamicFormsPage extends StatefulWidget {
  const DynamicFormsPage({super.key});

  @override
  _DynamicFormsPageState createState() => _DynamicFormsPageState();
}

class _DynamicFormsPageState extends State<DynamicFormsPage> {
  late Future<List<dynamic>> _forms;

  @override
  void initState() {
    super.initState();
    _forms = DynamicFormService().fetchForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyText(
          text: 'Formulaires Dynamiques',
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _forms = DynamicFormService().fetchForms();
            }),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<List<dynamic>>(
          future: _forms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    MyText(text: 'Chargement des formulaires...'),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const MyText(
                      text: 'Erreur de chargement',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _forms = DynamicFormService().fetchForms();
                      }),
                      child: const MyText(text: 'Réessayer'),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(
                child: MyText(text: 'Aucun formulaire disponible'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _forms = DynamicFormService().fetchForms();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var form = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow[600]!)),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DynamicFormScreen(form: form),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              child: MyText(
                                text: form.name[0].toUpperCase(),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: form.name,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  MyText(
                                    text: 'Tap pour remplir',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
