// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  const Login({Key? key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AccountProvider _accountProvider;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    _accountProvider = context.read<AccountProvider>();
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Barbershop',
              style: GoogleFonts.tiltNeon(fontSize: 55),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _usernameController,
                        validator: FormBuilderValidators.required(),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          prefixIcon: const Icon(Icons.person),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: FormBuilderValidators.required(),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Colors.black87,
                          )),
                    ),
                  ],
                )),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState?.validate() == true) {
                      var username = _usernameController.text;
                      var password = _passwordController.text;

                      await _accountProvider.login(username, password);

                      Navigator.popAndPushNamed(context, Home.routeName);
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
                  minimumSize: const Size(double.infinity, 55),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password ?',
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                )),
            const SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ?",
                  style: TextStyle(fontSize: 13),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    )),
              ],
            )
          ],
        ),
      )),
    );
  }
}
