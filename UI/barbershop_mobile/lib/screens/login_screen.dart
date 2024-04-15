// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_mobile/providers/account_provider.dart';
import 'package:barbershop_mobile/screens/navigation.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Form(
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
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: Colors.black87,
                            )),
                      ),
                    ],
                  )),
            ),
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

                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const Navigation());
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
                  'Log in',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ?",
                  style: TextStyle(fontSize: 15),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, RegisterScreen.routeName);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Color.fromRGBO(84, 181, 166, 1), fontSize: 15),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
