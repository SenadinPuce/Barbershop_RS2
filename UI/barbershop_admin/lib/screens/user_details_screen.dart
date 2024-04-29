// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:barbershop_admin/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/CustomPhotoFormField.dart';

class UserDetailsScreen extends StatefulWidget {
  User? user;

  UserDetailsScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  User? _editedUser;
  File? _image;
  String? _base64Image;
  late UserProvider _userProvider;
  bool _isPasswordVisible = false;
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.user?.photo != null) {
      _base64Image = widget.user!.photo;
    }

    _initialValue = {
      "firstName": widget.user?.firstName,
      "lastName": widget.user?.lastName,
      "username": widget.user?.username,
      "email": widget.user?.email,
      "phoneNumber": widget.user?.phoneNumber,
    };

    _userProvider = context.read<UserProvider>();
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
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                ),
                name: "firstName",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3)
                ]),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                ),
                name: "lastName",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3)
                ]),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                name: "username",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3)
                ]),
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
          height: 50,
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                name: "email",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ]),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
                name: "phoneNumber",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            )
          ],
        ),
        if (widget.user == null)
          const SizedBox(
            height: 50,
          ),
        if (widget.user == null)
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  onChanged: (value) {
                    setState(() {
                      _passwordController.text = value!;
                    });
                  },
                  name: "password",
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),

                  ]),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                  obscureText: true,
                  name: "confirmPassword",
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(4),
                    FormBuilderValidators.equal(
                      _passwordController.text,
                      errorText: 'Passwords do not match',
                    ),
                  ]),
                ),
              )
            ],
          ),
      ]),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            if (_editedUser != null) {
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop(false);
            }
          },
          child: const Text("Close"),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.saveAndValidate() == true) {
              var request = Map.from(_formKey.currentState!.value);

              request['photo'] = _base64Image;
              request['password'] = _passwordController.text;

              try {
                if (widget.user == null) {
                  _editedUser = await _userProvider.insert(request: request);
                } else {
                  _editedUser =
                      await _userProvider.update(widget.user!.id!, request);
                }

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text("User saved successfully.")
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
              } on Exception {
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
                          'Failed to save user. Please try again.',
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
        ),
      ],
    );
  }
}
