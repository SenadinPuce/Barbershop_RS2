import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../utils/util.dart'; 

class CustomPhotoFormField extends StatelessWidget {
  final String name;
  final String? Function(dynamic) validator;
  final void Function() onImageSelected;
  final String? base64Image;

  const CustomPhotoFormField({
    Key? key,
    required this.name,
    required this.validator,
    required this.onImageSelected,
    this.base64Image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(213, 178, 99, 1)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: base64Image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageFromBase64String(base64Image!),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No image selected',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                onImageSelected();
                field.didChange(
                    true); 
              },
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromRGBO(213, 178, 99, 1)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Color.fromRGBO(213, 178, 99, 1)),
                    SizedBox(width: 8),
                    Text(
                      'Select image',
                      style: TextStyle(color: Color.fromRGBO(213, 178, 99, 1)),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.file_upload,
                        color: Color.fromRGBO(213, 178, 99, 1)),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Text(
                field.errorText!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        );
      },
    );
  }
}
