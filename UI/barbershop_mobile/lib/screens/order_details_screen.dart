// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  Order? order;
  OrderDetailsScreen({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to orders", style: GoogleFonts.tiltNeon(fontSize: 25)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: const Column(children: []),
        ),
      )),
    );
  }
}
