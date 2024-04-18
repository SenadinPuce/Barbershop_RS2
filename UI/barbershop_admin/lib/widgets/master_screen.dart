import 'package:flutter/material.dart';

import '../screens/appointments_list_screen.dart';
import '../screens/login_screen.dart';
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
        automaticallyImplyLeading: true,
        title: Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountEmail: Text(
                Authorization.email.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              accountName: Text(
                'Welcome  ${Authorization.username.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              currentAccountPictureSize: const Size(70, 70),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
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
                    leading: const Icon(Icons.sell),
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
                    leading: const Icon(Icons.content_cut),
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
                    leading: const Icon(Icons.calendar_today),
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
                    leading: const Icon(Icons.shopping_cart),
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
                    leading: const Icon(Icons.bar_chart),
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
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  Authorization.username = "";
                  Authorization.email = "";
                  Authorization.token = "";

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
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
