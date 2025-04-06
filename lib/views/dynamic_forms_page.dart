import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/services/form_service.dart';
import '../services/form_sync_service.dart';
import 'dynamic_form_screen.dart';

class DynamicFormsPage extends StatefulWidget {
  const DynamicFormsPage({super.key});

  @override
  _DynamicFormsPageState createState() => _DynamicFormsPageState();
}

class _DynamicFormsPageState extends State<DynamicFormsPage> {
  late Future<List<dynamic>> _forms;
  late Timer _timer;
  List<dynamic> _cachedForms = [];
  final FormSyncService _syncService = FormSyncService();
  bool _isSyncing = false;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _forms = DynamicFormService().fetchForms();
    _checkPendingSubmissions();
    startAutoFetch();
  }

  void startAutoFetch() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchAndUpdateForms();
    });
  }

  Future<void> _checkPendingSubmissions() async {
    int count = await _syncService.getPendingSubmissionsCount();
    setState(() {
      _pendingCount = count;
    });
  }

  Future<void> fetchAndUpdateForms() async {
    try {
      List<dynamic> newForms = await DynamicFormService().fetchForms();

      // Verify if new data is different before refreshing
      if (newForms.toString() != _cachedForms.toString()) {
        setState(() {
          _forms = Future.value(newForms);
          _cachedForms = newForms;
        });
      }
    } catch (e) {
      debugPrint("Error loading forms: $e");
    }
  }

  Future<void> syncAllPendingForms() async {
    bool isConnected = await _checkConnectivity();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      Map<String, dynamic> result =
          await _syncService.syncAllPendingSubmissions();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sync error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      await _checkPendingSubmissions();
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
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
          if (_pendingCount > 0)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: _isSyncing ? null : syncAllPendingForms,
                ),
                if (_isSyncing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _pendingCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "Quitter") {
                Navigator.pop(context);
              } else if (value == "Synchronisation") {
                await syncAllPendingForms();
              } else if (value == "Actualisation") {
                fetchAndUpdateForms();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Synchronisation",
                child: Text("Synchronisation"),
              ),
              const PopupMenuItem(
                value: "Actualisation",
                child: Text("Actualisation"),
              ),
              const PopupMenuItem(
                value: "Quitter",
                child: Text("Quitter"),
              ),
            ],
            icon: const Icon(Icons.more_vert),
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
                      onPressed: fetchAndUpdateForms,
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
                await fetchAndUpdateForms();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var form = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow[600]!),
                        borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DynamicFormScreen(form: form),
                          ),
                        );
                        // Check for pending submissions after returning from form screen
                        _checkPendingSubmissions();
                      },
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
      floatingActionButton: _pendingCount > 0
          ? FloatingActionButton(
              onPressed: _isSyncing ? null : syncAllPendingForms,
              backgroundColor: Colors.green[800],
              child: _isSyncing
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Icon(Icons.sync, color: Colors.white),
            )
          : null,
    );
  }
}
