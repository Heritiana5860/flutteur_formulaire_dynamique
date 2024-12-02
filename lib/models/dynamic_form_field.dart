class DynamicFormField {
  final String name;
  final String type;
  final bool required;
  final List<dynamic>? options;

  DynamicFormField({
    required this.name,
    required this.type,
    this.required = false,
    this.options,
  });

  factory DynamicFormField.fromJson(Map<String, dynamic> json) {
    return DynamicFormField(
      name: json['name'],
      type: json['type'],
      required: json['required'] ?? false,
      options: json['options'],
    );
  }
}
