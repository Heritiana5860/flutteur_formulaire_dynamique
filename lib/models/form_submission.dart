import 'dart:convert';

class FormSubmission {
  final int? id;
  final int formId;
  final Map<String, dynamic> data;
  final DateTime submittedAt;
  final bool isSynced;

  FormSubmission({
    this.id,
    required this.formId,
    required this.data,
    required this.submittedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'form': formId,
      'data': jsonEncode(data),
      'submitted_at': submittedAt.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
    };
  }

  factory FormSubmission.fromMap(Map<String, dynamic> map) {
    return FormSubmission(
      id: map['id'],
      formId: map['form'],
      data: map['data'] is String ? jsonDecode(map['data']) : map['data'],
      submittedAt: DateTime.parse(map['submitted_at']),
      isSynced: map['is_synced'] == 1,
    );
  }

  FormSubmission copyWith({
    int? id,
    int? formId,
    Map<String, dynamic>? data,
    DateTime? submittedAt,
    bool? isSynced,
  }) {
    return FormSubmission(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      data: data ?? this.data,
      submittedAt: submittedAt ?? this.submittedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
