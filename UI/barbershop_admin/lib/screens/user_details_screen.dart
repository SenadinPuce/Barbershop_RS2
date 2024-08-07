import 'dart:convert';
import 'dart:io';

import 'package:barbershop_admin/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/CustomPhotoFormField.dart';

class UserDetailsScreen extends StatefulWidget {
  final User? user;

  const UserDetailsScreen({
    super.key,
    this.user,
  });

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
  final TextEditingController _passwordController = TextEditingController();
  final List<String> _allRoles = ['Client', 'Barber', 'Admin'];
  bool _isSending = false;

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
      "roles": widget.user?.roles ?? <String>[]
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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
        const SizedBox(height: 15),
        const Text(
          "User data",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                  hintText: 'e.g. 061 234 456',
                ),
                name: "phoneNumber",
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                inputFormatters: [
                  PhoneInputFormatter(
                    defaultCountryCode: 'BA',
                    allowEndlessPhone: false,
                  )
                ],
              ),
            )
          ],
        ),
        if (widget.user == null)
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
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
            ],
          ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "User roles",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        FormBuilderCheckboxGroup(
            name: 'roles',
            validator: (value) =>
                value!.isEmpty ? 'Please select at least one role' : null,
            wrapSpacing: 30,
            options: _allRoles
                .map((role) => FormBuilderFieldOption(
                      value: role,
                      child: Text(role),
                    ))
                .toList())
      ]),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _isSending
              ? null
              : () {
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
          onPressed: _isSending
              ? null
              : () async {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    setState(() {
                      _isSending = true;
                    });
                    var request = Map.from(_formKey.currentState!.value);

                    request['photo'] = _base64Image;
                    request['password'] = _passwordController.text;
                    request['roles'] = request['roles'].join(',');

                    try {
                      if (widget.user == null) {
                        _editedUser =
                            await _userProvider.insert(request: request);
                      } else {
                        _editedUser = await _userProvider.update(
                            widget.user!.id!, request);
                      }
                      if (!context.mounted) return;

                      Navigator.of(context).pop(true);
                    } on Exception {
                      setState(() {
                        _isSending = false;
                      });

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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      );
                    }
                  }
                },
          child: _isSending
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                )
              : const Text("Save changes"),
        ),
      ],
    );
  }
}
