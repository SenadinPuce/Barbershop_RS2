import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';

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
        children: [Text("Profile screen content will go here!")],
      )),
    );
  }
}
