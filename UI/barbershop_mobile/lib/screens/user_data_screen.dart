import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'package:barbershop_mobile/models/user.dart';
import 'package:barbershop_mobile/providers/user_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late UserProvider _userProvider;
  late AccountProvider _accountProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  User? _user;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _userProvider = context.read<UserProvider>();
    _accountProvider = context.read<AccountProvider>();

    var userData = await _userProvider.getById(Authorization.id!);

    setState(() {
      _user = userData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Personal data'),
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [if (_user != null) _buildView()],
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ])),
    );
  }

  Widget _buildView() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'firstName': _user!.firstName ?? '',
        'lastName': _user!.lastName ?? '',
        'username': _user!.username ?? '',
        'email': _user!.email ?? '',
        'phoneNumber': _user!.phoneNumber ?? '',
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormBuilderTextField(
            name: 'firstName',
            decoration: const InputDecoration(labelText: 'First Name'),
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
            decoration:
                const InputDecoration(labelText: 'Phone Number (optional)'),
            inputFormatters: [
              PhoneInputFormatter(
                allowEndlessPhone: false,
                defaultCountryCode: 'BA',
              )
            ],
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderTextField(
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
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
              FormBuilderValidators.minLength(4, allowEmpty: true),
            ]),
          ),
          const SizedBox(
            height: 5,
          ),
          FormBuilderTextField(
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
          const SizedBox(height: 20),
          _buildSubmitButton()
        ],
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
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        onPressed: _isSending
            ? null
            : () async {
                if (_formKey.currentState?.saveAndValidate() == true) {
                  try {
                    setState(() {
                      _isSending = true;
                    });

                    var request = Map.from(_formKey.currentState!.value);

                    await _accountProvider.update(request: request);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        showCloseIcon: true,
                        closeIconColor: Colors.white,
                        duration: Duration(seconds: 1),
                        content: Text('Personal data updated successfully.'),
                      ),
                    );
                    setState(() {
                      _isSending = false;
                    });
                  } on Exception {
                    setState(() {
                      _isSending = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                          duration: Duration(seconds: 1),
                          content: Text(
                              'Failed to update personal data. Please try again.')),
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
            : const Text(
                'Save changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
