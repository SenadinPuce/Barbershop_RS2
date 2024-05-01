import 'package:barbershop_mobile/models/order.dart';
import 'package:barbershop_mobile/providers/order_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_details_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  late OrderProvider _orderProvider;
  List<Order>? _orders;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _orderProvider = context.read<OrderProvider>();

    var orderData = await _orderProvider.get(filter: {
      'clientId': Authorization.id,
      'includeClient': true,
      'includeAddress': true,
      'includeDeliveryMethod': true,
    });

    setState(() {
      _orders = orderData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your orders'),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [if (_orders != null) _buildView()],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      )),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _orders?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return _buildOrderTile(_orders?[index]);
          });
    }
  }

  Widget _buildOrderTile(Order? order) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blueGrey[50],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(order: order),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Number: # ${order?.id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${formatDate(order?.orderDate)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Total: \$${formatNumber(order?.total)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      'Status: ${order!.status!}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
