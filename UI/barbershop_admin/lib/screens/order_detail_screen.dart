// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../widgets/master_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  Order? order;
  OrderDetailsScreen({
    super.key,
    this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Order details',
      child: const Text("Order details will go here!"),
    );
  }
}
