import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formulaire_dynamique/db_helper/database_helper.dart';
import 'package:http/http.dart' as http;
import '../models/form_submission.dart';

class FormSyncService {
  final String baseUrl = dotenv.env['URLSEND'] ?? '';
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> syncSubmission(FormSubmission submission) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'form': submission.formId,
          'data': submission.data,
          'submitted_at': submission.submittedAt.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        // Successfully synced, mark as synced in local DB
        await _dbHelper.markSubmissionSynced(submission.id!);
        return true;
      } else {
        debugPrint('Failed to sync submission: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error syncing submission: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> syncAllPendingSubmissions() async {
    int successCount = 0;
    int failCount = 0;
    List<FormSubmission> unsynced = await _dbHelper.getUnSyncedSubmissions();

    if (unsynced.isEmpty) {
      return {
        'success': true,
        'message': 'No pending submissions to sync',
        'syncedCount': 0,
        'failedCount': 0,
      };
    }

    for (var submission in unsynced) {
      bool success = await syncSubmission(submission);
      if (success) {
        successCount++;
      } else {
        failCount++;
      }
    }

    return {
      'success': failCount == 0,
      'message': 'Sync completed: $successCount synced, $failCount failed',
      'syncedCount': successCount,
      'failedCount': failCount,
    };
  }

  Future<int> getPendingSubmissionsCount() async {
    return await _dbHelper.getUnsyncedSubmissionsCount();
  }
  
}
