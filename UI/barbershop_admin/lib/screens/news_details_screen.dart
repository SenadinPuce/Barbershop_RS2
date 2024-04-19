// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:barbershop_admin/providers/news_provider.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:barbershop_admin/widgets/CustomPhotoFormField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';

class NewsDetailsScreen extends StatefulWidget {
  News? news;
  NewsDetailsScreen({
    Key? key,
    this.news,
  }) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NewsProvider _newsProvider;
  File? _image;
  String? _base64Image;
  News? _editedNews;

  @override
  void initState() {
    super.initState();
    _newsProvider = context.read<NewsProvider>();

    initForm();
  }

  initForm() {
    if (widget.news?.photo != null) {
      _base64Image = widget.news?.photo;
    }

    _initialValue = {
      'title': widget.news?.title,
      'content': widget.news?.content,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildForm(),
            const SizedBox(
              height: 20,
            ),
            _buildButtons()
          ],
        )),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'title',
                    validator: FormBuilderValidators.required(),
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CustomPhotoFormField(
                  name: 'photo',
                  validator: (value) {
                    if (_base64Image == null) {
                      return 'Please select an image';
                    }
                    return null;
                  },
                  onImageSelected: getImage,
                  base64Image: _base64Image,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FormBuilderTextField(
              name: 'content',
              validator: FormBuilderValidators.required(),
              maxLines: 5,
              decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: _initialValue['content'] != null
                      ? ''
                      : 'Enter your content here',
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
            ),
          ],
        ));
  }

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            if (_editedNews != null) {
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop(false);
            }
          },
          child: const Text(
            "Close",
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.saveAndValidate() == true) {
              try {
                var request = Map.from(_formKey.currentState!.value);

                request['photo'] = _base64Image;

                if (widget.news == null) {
                  request['authorId'] = Authorization.id;
                  _editedNews = await _newsProvider.insert(request: request);
                } else {
                  _editedNews = await _newsProvider.update(
                    widget.news!.id!,
                    request,
                  );
                }

                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text("News saved successfully.")
                    ],
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    textColor: Colors.white,
                  ),
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Failed to save news. Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      textColor: Colors.white,
                    ),
                  ),
                );
              }
            }
          },
          child: const Text("Save changes"),
        )
      ],
    );
  }
}
