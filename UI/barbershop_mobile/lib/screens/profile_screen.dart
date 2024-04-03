import 'package:barbershop_mobile/screens/login_screen.dart';
import 'package:barbershop_mobile/screens/user_address_screen.dart';
import 'package:barbershop_mobile/screens/user_data_screen.dart';
import 'package:barbershop_mobile/screens/user_orders_screen.dart';
import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/util.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                _buildView(),
              ],
            ),
          ),
        ),
        _buildLogOutOption(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
          child: Text(
        "Profile",
        style: GoogleFonts.tiltNeon(color: Colors.black, fontSize: 35),
      )),
    );
  }

  Widget _buildView() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.amber[700],
          ),
          title: const Text(
            "Personal data",
            style: TextStyle(color: Colors.black),
          ),
          subtitle: const Text("View or update your personal information",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserDataScreen()));
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.amber[700]),
          title: const Text("Address", style: TextStyle(color: Colors.black)),
          subtitle: const Text("View or update your delivery address",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserAddressScreen()));
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading: Icon(Icons.history, color: Colors.amber[700]),
          title: const Text("Order History",
              style: TextStyle(color: Colors.black)),
          subtitle: const Text("View your past orders",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserOrdersScreen()));
          },
        ),
      ],
    );
  }

  Widget _buildLogOutOption() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Authorization.username = "";
          Authorization.email = "";
          Authorization.token = "";

          ButtomNavigationBarHelper.currentIndex = 0;

          Navigator.pushNamed(context, LoginScreen.routeName);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 3,
            minimumSize: const Size(double.infinity, 45)),
        icon: const Icon(Icons.logout, size: 25.0),
        label: const Text(
          "Log Out",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
