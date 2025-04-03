import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';

class CheckboxgroupField extends StatefulWidget {
  const CheckboxgroupField(
      {super.key, required this.formData, required this.field});

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  State<CheckboxgroupField> createState() => _CheckboxgroupFieldState();
}

class _CheckboxgroupFieldState extends State<CheckboxgroupField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormField<List<String>>(
        initialValue: widget.formData[widget.field.name],
        validator: widget.field.required
            ? (value) => (value?.isEmpty ?? true)
                ? 'Sélectionnez au moins une option'
                : null
            : null,
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow[600]!, width: 1.5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyText(
                        text: widget.field.label ?? widget.field.name,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...widget.field.options?.map((option) {
                          return CheckboxListTile(
                            title: MyText(text: option.toString()),
                            value: (widget.formData[widget.field.name]
                                    as List<String>)
                                .contains(option),
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.green.shade700,
                            dense: true,
                            onChanged: (checked) {
                              setState(() {
                                final list = List<String>.from(
                                    widget.formData[widget.field.name]);
                                if (checked == true) {
                                  if (!list.contains(option)) {
                                    list.add(option.toString());
                                  }
                                } else {
                                  list.remove(option.toString());
                                }
                                widget.formData[widget.field.name] = list;
                                formState.didChange(list);
                              });
                            },
                          );
                        }).toList() ??
                        [],
                  ],
                ),
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
