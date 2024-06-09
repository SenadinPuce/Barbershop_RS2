import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProvider _userProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  User? _user;
  bool isLoading = true;
  bool isFormEdited = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _userProvider = context.read<UserProvider>();

    var userData = await _userProvider.getById(Authorization.id!);

    setState(() {
      _user = userData;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [if (_user != null) _buildView()],
      ),
    );
  }

  Widget _buildView() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                initialValue: {
                  'firstName': _user!.firstName ?? '',
                  'lastName': _user!.lastName ?? '',
                  'username': _user!.username ?? '',
                  'email': _user!.email ?? '',
                  'phoneNumber': _user!.phoneNumber ?? '',
                },
                onChanged: () {
                  setState(() {
                    isFormEdited = true;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Personal Data',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'firstName',
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FormBuilderTextField(
                      name: 'lastName',
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FormBuilderTextField(
                      name: 'username',
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email()
                      ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FormBuilderTextField(
                      name: 'phoneNumber',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (optional)',
                        hintText: ('e.g. 061 234 456'),
                      ),
                      inputFormatters: [
                        PhoneInputFormatter(
                          defaultCountryCode: 'BA',
                          allowEndlessPhone: false,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
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
                              labelText: 'Password (optional)',
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
                              FormBuilderValidators.minLength(4,
                                  allowEmpty: true),
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
                              validator: (value) {
                                if (_passwordController.text.isNotEmpty) {
                                  if (value != _passwordController.text) {
                                    return 'Password do not match';
                                  }
                                }
                                return null;
                              }),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSubmitButton()
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
        ),
        onPressed: isFormEdited
            ? () async {
                try {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    var request = Map.from(_formKey.currentState!.value);

                    if (_passwordController.text.isNotEmpty) {
                      request['password'] = _passwordController.text;
                    }

                    await _userProvider.update(Authorization.id!, request);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text("Personal data updated successfully.")
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
                  }
                } on Exception catch (e) {
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
                            'Failed to update user data. Please try again.',
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
            : null,
        child: const Text(
          'Save changes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
