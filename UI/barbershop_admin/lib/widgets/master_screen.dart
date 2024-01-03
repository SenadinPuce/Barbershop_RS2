import 'package:barbershop_admin/main.dart';
import 'package:barbershop_admin/screens/products_list_screen.dart';
import 'package:barbershop_admin/screens/users_list_screen.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:flutter/material.dart';

import '../screens/services_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;

  MasterScreenWidget({
    Key? key,
    this.child,
    this.title,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Users"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UsersListScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Products"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductsListScreen(),
                        ),
                      );
                    },
                  ),
                   ListTile(
                    title: const Text("Services"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ServicesListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text("Logout"),
                onTap: () {
                  Authorization.username = "";
                  Authorization.email = "";
                  Authorization.token = "";

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
