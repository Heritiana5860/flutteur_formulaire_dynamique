class DynamicFormField {
  final String name;
  final String type;
  final bool required;
  final List<dynamic>? options;
  final String? label;
  final double? min;
  final double? max;
  final double? step;

  DynamicFormField({
    required this.name,
    required this.type,
    required this.required,
    this.options,
    this.label,
    this.min,
    this.max,
    this.step,
  });

  factory DynamicFormField.fromJson(Map<String, dynamic> json) {
    return DynamicFormField(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      required: json['required'] ?? false,
      options: json['options'] as List<dynamic>?,
      label: json['label'] as String?,
      min: json['min']?.toDouble(),
      max: json['max']?.toDouble(),
      step: json['step']?.toDouble(),
    );
  }
}
