import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class SliderField extends StatefulWidget {
  const SliderField(
      {super.key,
      required this.formData,
      required this.field,
      required this.min,
      required this.max,
      required this.step});

  final Map<String, dynamic> formData;
  final DynamicFormField field;
  final double min, max, step;

  @override
  State<SliderField> createState() => _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormField<double>(
        initialValue: widget.formData[widget.field.name],
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text:
                    '${widget.field.name}: ${widget.formData[widget.field.name].toStringAsFixed(1)}',
                fontWeight: FontWeight.bold,
              ),
              Slider(
                value: widget.formData[widget.field.name],
                min: widget.min,
                max: widget.max,
                thumbColor: Colors.green.shade700,
                divisions: ((widget.max - widget.min) / widget.step).round(),
                label: widget.formData[widget.field.name].toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    widget.formData[widget.field.name] = value;
                    formState.didChange(value);
                  });
                },
              ),
            ],
          );
        },
        onSaved: (value) => widget.formData[widget.field.name] = value,
      ),
    );
  }
}
