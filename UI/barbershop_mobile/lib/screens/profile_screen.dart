import 'package:barbershop_mobile/screens/login_screen.dart';
import 'package:barbershop_mobile/screens/user_address_screen.dart';
import 'package:barbershop_mobile/screens/user_data_screen.dart';
import 'package:barbershop_mobile/screens/user_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../utils/util.dart';
import 'user_appointments_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
        ],
      ),
      floatingActionButton: _buildLogOutOption(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
          child: Text(
        "Profile",
        style: TextStyle(color: Colors.black, fontSize: 35),
      )),
    );
  }

  Widget _buildView() {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          leading: const Icon(
            Icons.person,
            color: Color.fromRGBO(213, 178, 99, 1),
          ),
          title: const Text(
            "Personal data",
            style: TextStyle(color: Colors.black),
          ),
          subtitle: const Text("View or update your personal information",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromRGBO(57, 131, 120, 1)),
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const UserDataScreen());
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading: const Icon(
            Icons.location_on,
            color: Color.fromRGBO(213, 178, 99, 1),
          ),
          title: const Text("Address", style: TextStyle(color: Colors.black)),
          subtitle: const Text("View or update your delivery address",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromRGBO(57, 131, 120, 1)),
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const UserAddressScreen());
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading: const Icon(
            Icons.calendar_today,
            color: Color.fromRGBO(213, 178, 99, 1),
          ),
          title:
              const Text("Appointments", style: TextStyle(color: Colors.black)),
          subtitle: const Text("View your appointments",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromRGBO(57, 131, 120, 1)),
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const UserAppointmentsScreen());
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading:
              const Icon(Icons.history, color: Color.fromRGBO(213, 178, 99, 1)),
          title: const Text("Order History",
              style: TextStyle(color: Colors.black)),
          subtitle: const Text("View your past orders",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward,
              color: Color.fromRGBO(57, 131, 120, 1)),
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: const UserOrdersScreen());
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

          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            context,
            settings: const RouteSettings(name: LoginScreen.routeName),
            screen: const LoginScreen(),
            withNavBar: false,
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfff71133),
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
