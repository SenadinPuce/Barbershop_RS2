import 'package:barbershop_mobile/screens/user_data_screen.dart';
import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
          child: Column(
        children: [_buildHeader(), _buildView()],
      )),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserDataScreen()));
          },
        ),
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.amber[700]),
          title: const Text("Address", style: TextStyle(color: Colors.black)),
          subtitle: const Text("View or update your address",
              style: TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
          onTap: () {},
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
          onTap: () {},
        ),
      ],
    );
  }
}
