import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Users",
      child: Container(
        child: Column(children: [
          Text("Asbi")
        ],),
      ),
    );
  }
}