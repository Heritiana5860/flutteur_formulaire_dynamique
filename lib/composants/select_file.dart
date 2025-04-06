import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:formulaire_dynamique/composants/my_text.dart';
import 'package:formulaire_dynamique/models/dynamic_form_field.dart';
import 'package:open_file_plus/open_file_plus.dart';

class SelectFile extends StatefulWidget {
  const SelectFile({super.key, required this.formData, required this.field});

  final Map<String, dynamic> formData;
  final DynamicFormField field;

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FormField<Map<String, dynamic>>(
        initialValue: widget.formData[widget.field.name],
        validator: widget.field.required
            ? (value) => value == null ? 'Ce champ est requis' : null
            : null,
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result == null) return;

                  // Get file details
                  final file = result.files.first;

                  // Save file information
                  final fileData = {
                    'name': file.name,
                    'path': file.path,
                    'size': file.size,
                    'extension': file.extension
                  };

                  // Update form data and state
                  setState(() {
                    widget.formData[widget.field.name] = fileData;
                    formState.didChange(fileData);
                  });

                  // Open the file
                  openFile(file);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          formState.hasError ? Colors.red : Colors.yellow[600]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MyText(
                              text: widget.field.label ?? widget.field.name,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.upload_file),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (widget.formData[widget.field.name] != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.formData[widget.field.name]['name'],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.formData[widget.field.name] = null;
                                  formState.didChange(null);
                                });
                              },
                            ),
                          ],
                        ),
                      ] else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'Cliquez ici pour sélectionner un fichier',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
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

  void openFile(PlatformFile file) {
    if (file.path != null) {
      OpenFile.open(file.path!);
    } else {
      debugPrint("Le chemin du fichier est null !");
    }
  }
}
