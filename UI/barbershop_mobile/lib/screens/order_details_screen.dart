import 'package:barbershop_mobile/widgets/back_button_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/order.dart';
import '../utils/util.dart';

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
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Number: # ${widget.order?.id}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromRGBO(213, 178, 99, 1),
                thickness: 2,
              ),
              Text('Date: ${formatDate(widget.order?.orderDate)}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Subtotal: ${formatNumber(widget.order?.subtotal)} \$ ',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                  'Delivery Price: ${formatNumber(widget.order!.deliveryMethod?.price)} \$',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              const Divider(
                thickness: 2,
                color: Color.fromRGBO(213, 178, 99, 1),
              ),
              Text('Total: ${formatNumber(widget.order?.total)} \$',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Divider(
                thickness: 2,
                color: Color.fromRGBO(213, 178, 99, 1),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('Email: ${widget.order?.clientEmail}',
                  style: const TextStyle(fontSize: 18)),
              Text('Phone Number: ${widget.order?.clientPhoneNumber}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text(
                'Delivery Address:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                  'Name: ${widget.order?.address?.firstName} ${widget.order?.address?.lastName}',
                  style: const TextStyle(fontSize: 18)),
              Text('Street: ${widget.order?.address?.street}',
                  style: const TextStyle(fontSize: 18)),
              Text('City: ${widget.order?.address?.city}',
                  style: const TextStyle(fontSize: 18)),
              Text('State: ${widget.order?.address?.state}',
                  style: const TextStyle(fontSize: 18)),
              Text('Zip Code: ${widget.order?.address?.zipCode}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text(
                'Order Items:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              if (widget.order != null && widget.order!.orderItems != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.order!.orderItems!.map((item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (item.photo != null)
                              SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: imageFromBase64String(item.photo!)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product Name: ${item.productName}',
                                      style: const TextStyle(fontSize: 18)),
                                  Text('Price Per Item: \$${item.price}',
                                      style: const TextStyle(fontSize: 18)),
                                  Text('Quantity: ${item.quantity}',
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              const Text(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('${widget.order?.status}',
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
