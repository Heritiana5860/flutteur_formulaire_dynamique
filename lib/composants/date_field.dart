import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';
import 'package:intl/intl.dart';

class DateFields extends StatefulWidget {
  const DateFields({super.key, required this.formData, required this.field});

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  State<DateFields> createState() => _DateFieldsState();
}

class _DateFieldsState extends State<DateFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormField<String>(
        initialValue: widget.formData[widget.field.name],
        validator: widget.field.required
            ? (value) => value?.isEmpty == true ? 'Ce champ est requis' : null
            : null,
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      widget.formData[widget.field.name] = formattedDate;
                      formState.didChange(formattedDate);
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: widget.field.name,
                    labelStyle: const TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide:
                          BorderSide(color: Colors.yellow[600]!, width: 1.5),
                    ),
                    suffixIcon: Icon(Icons.calendar_today,
                        color: Colors.green.shade700),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.yellow[600]!, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.green.shade700, width: 1.5),
                    ),
                  ),
                  child: Text(
                    widget.formData[widget.field.name] != null
                        ? DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(widget.formData[widget.field.name]))
                        : 'Sélectionner une date',
                    style: TextStyle(
                      color: widget.formData[widget.field.name] != null
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
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
