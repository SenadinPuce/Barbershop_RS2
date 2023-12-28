import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "User details",
      child: Container(child: Text("User details")),
    );
  }
}
