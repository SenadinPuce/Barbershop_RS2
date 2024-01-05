import 'package:flutter/material.dart';

import '../widgets/master_screen.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Appointment details',
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text("Screen for adding new appointments"),
      ),
    );
  }
}
