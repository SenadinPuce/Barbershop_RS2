import 'package:barbershop_admin/main.dart';
import 'package:barbershop_admin/screens/users_list_screen.dart';
import 'package:barbershop_admin/utils/util.dart';
import 'package:flutter/material.dart';

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
        child: ListView(
          children: [
            ListTile(
              title: Text("Users"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const UsersListScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                Authorization.username = "";
                Authorization.email = "";
                Authorization.token = "";

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
