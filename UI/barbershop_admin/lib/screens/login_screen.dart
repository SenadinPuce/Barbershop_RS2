// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/account_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return LoginStatefulWidget();
  }
}

class LoginStatefulWidget extends StatefulWidget {
  LoginStatefulWidget({Key? key});

  @override
  _LoginStatefulWidgetState createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late AccountProvider _accountProvider;
  bool isButtonDisabled = true;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      isButtonDisabled =
          _usernameController.text.isEmpty || _passwordController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = context.read<AccountProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            child: Card(
              elevation: 2.0,
              color: Colors.blueGrey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 200,
                      width: 270,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      controller: _usernameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () async {
                                var username = _usernameController.text;
                                var password = _passwordController.text;

                                try {
                                  await _accountProvider.loginAsync(
                                      username, password);

                                  Navigator.pushReplacementNamed(
                                      context, Navigation.routeName);
                                } on Exception catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text("Error"),
                                            content: Text(e.toString()),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("OK"))
                                            ],
                                          ));
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45)),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
