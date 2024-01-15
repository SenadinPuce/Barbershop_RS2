import 'package:barbershop_admin/main.dart';
import 'package:flutter/material.dart';

import '../screens/appointments_list_screen.dart';
import '../screens/orders_list_screen.dart';
import '../screens/products_list_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/services_list_screen.dart';
import '../screens/users_list_screen.dart';
import '../utils/util.dart';

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
                          builder: (context) => const ProductsListScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Services"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ServicesListScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Appointments"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AppointmentsListScreen(),
                        ),
                      );
                    },
                  ),
                   ListTile(
                    title: const Text("Orders"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrdersListScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Reports"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReportsScreen(),
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
