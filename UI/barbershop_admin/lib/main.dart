// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_build_context_synchronously

import 'package:barbershop_admin/providers/account_provider.dart';
import 'package:barbershop_admin/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/users_list_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barbershop admin',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

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
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    controller: _usernameController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: isButtonDisabled
                        ? null // Disable the button if isButtonDisabled is true
                        : () async {
                            var username = _usernameController.text;
                            var password = _passwordController.text;

                            try {
                              await _accountProvider.loginAsync(
                                  username, password);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => UsersListScreen()),
                              );
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("OK"))
                                        ],
                                      ));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(400, 50),
                      elevation: 3,
                    ),
                    child: Text("Sign in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
