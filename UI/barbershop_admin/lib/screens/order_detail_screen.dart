import 'package:barbershop_admin/models/order_item.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import '../utils/util.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'User Information',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _userInformation(),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Shipping address',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _addressInformation(),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Delivery information',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _deliveryInformation(),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Order items',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _orderItemsInformation(),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Order summary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _summaryInformation(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: const Text("Close"),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget _userInformation() {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.clientUsername,
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.clientEmail,
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Phone number',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.clientPhoneNumber,
        )),
      ],
    );
  }

  Widget _addressInformation() {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'On name',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue:
              '${widget.order?.address?.firstName} ${widget.order?.address?.lastName}',
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Street',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.address?.street,
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.address?.city,
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Zip code',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.address?.zipCode,
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'State',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.address?.state,
        )),
      ],
    );
  }

  Widget _deliveryInformation() {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery name',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabled: false,
                ),
                style: const TextStyle(color: Colors.black),
                initialValue: widget.order?.deliveryMethod?.shortName)),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery time',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabled: false,
                ),
                style: const TextStyle(color: Colors.black),
                initialValue: widget.order!.deliveryMethod?.deliveryTime)),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabled: false,
                ),
                style: const TextStyle(color: Colors.black),
                initialValue: widget.order!.deliveryMethod?.description)),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Price',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: formatNumber(widget.order!.deliveryMethod?.price),
        )),
      ],
    );
  }

  Widget _orderItemsInformation() {
    return Column(
      children: [
        ...(widget.order?.orderItems
                ?.map((orderItem) => _orderItemWidget(orderItem)) ??
            []),
      ],
    );
  }

  Widget _orderItemWidget(OrderItem orderItem) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        // child: Image.network(
        //   orderItem.pictureUrl.toString(),
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        // ),
      ),
      title: Text(
        orderItem.productName.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity: ${orderItem.quantity}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            'Price per piece: ${orderItem.price ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: Text(
        'Total Price: ${(orderItem.quantity ?? 0) * (orderItem.price ?? 0)}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _summaryInformation() {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Order date',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabled: false,
                ),
                style: const TextStyle(color: Colors.black),
                initialValue: getDate(widget.order?.orderDate))),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Subtotal',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: formatNumber(widget.order?.subtotal),
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Total',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: formatNumber(widget.order?.total),
        )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Status',
            labelStyle: TextStyle(color: Colors.blue),
            enabled: false,
          ),
          style: const TextStyle(color: Colors.black),
          initialValue: widget.order?.status,
        )),
      ],
    );
  }
}
