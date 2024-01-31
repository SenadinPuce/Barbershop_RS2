import 'package:flutter/material.dart';

class Appointments extends StatefulWidget {
  static const routeName = '/appointments';
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text("Appointments will go here"),
      )),
    );
  }
}
