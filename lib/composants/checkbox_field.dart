import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class CheckboxField extends StatefulWidget {
  const CheckboxField({super.key, required this.formData, required this.field});

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormField<bool>(
        initialValue: widget.formData[widget.field.name],
        validator: widget.field.required
            ? (value) => value != true ? 'Ce champ est requis' : null
            : null,
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: MyText(text: widget.field.label ?? widget.field.name),
                value: widget.formData[widget.field.name],
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.green.shade700,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Colors.yellow[600]!, width: 1.5),
                ),
                onChanged: (newValue) {
                  setState(() {
                    widget.formData[widget.field.name] = newValue;
                    formState.didChange(newValue);
                  });
                },
              ),
              if (formState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 5.0),
                  child: Text(
                    formState.errorText!,
                    style: TextStyle(color: Colors.red[700], fontSize: 12.0),
                  ),
                ),
            ],
          );
        },
        onSaved: (value) => widget.formData[widget.field.name] = value,
      ),
    );
  }
}
