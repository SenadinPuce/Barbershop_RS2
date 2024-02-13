// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'news_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AccountProvider _accountProvider;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            Text(
              'Barbershop',
              style: GoogleFonts.tiltNeon(fontSize: 55),
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _usernameController,
                        validator: FormBuilderValidators.required(),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter username',
                          prefixIcon: Icon(Icons.person),
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: FormBuilderValidators.required(),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
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
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState?.validate() == true) {
                      var username = _usernameController.text;
                      var password = _passwordController.text;

                      await _accountProvider.login(username, password);

                      Navigator.popAndPushNamed(context, NewsListScreen.routeName);
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
                  'Log in',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ?",
                  style: TextStyle(fontSize: 13),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, RegisterScreen.routeName);
                    },
                    child: const Text(
                      'Register',
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
