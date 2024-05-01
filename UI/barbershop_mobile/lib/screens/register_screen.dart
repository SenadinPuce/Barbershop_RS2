// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';
import 'navigation.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({Key? key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AccountProvider _accountProvider;
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'firstName',
                          validator: FormBuilderValidators.required(),
                          decoration: const InputDecoration(
                            labelText: 'First name',
                            hintText: 'Enter First name',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FormBuilderTextField(
                          name: 'lastName',
                          validator: FormBuilderValidators.required(),
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            hintText: 'Enter Last name',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FormBuilderTextField(
                          name: 'userName',
                          validator: FormBuilderValidators.required(),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter Username',
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FormBuilderTextField(
                          name: 'email',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email()
                          ]),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email',
                          ),
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
                            FormBuilderValidators.minLength(
                              4,
                            ),
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
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState?.saveAndValidate() == true) {
                          var request = Map.from(_formKey.currentState!.value);

                          await _accountProvider.register(request);

                          Navigator.pushReplacementNamed(
                              context, Navigation.routeName);
                        }
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Ok"))
                                  ],
                                ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                    ),
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "I have an account ?",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                              color: Color.fromRGBO(84, 181, 166, 1),
                              fontSize: 15),
                        )),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
