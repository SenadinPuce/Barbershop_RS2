// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

import '../models/service.dart';

class ServiceDetailScreen extends StatefulWidget {
  Service? service;
  ServiceDetailScreen({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Service details",
      child: Text("Service details"),
    );
  }
}
