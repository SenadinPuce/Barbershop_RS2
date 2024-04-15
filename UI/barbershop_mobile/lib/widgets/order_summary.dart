import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../utils/util.dart';

class OrderSummaryWidget extends StatelessWidget {
  final CartProvider cartProvider;

  const OrderSummaryWidget({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subtotal = _calculateSubtotal();
    double deliveryCharge = cartProvider.selectedDeliveryMethod?.price ?? 0;
    double total = subtotal + deliveryCharge;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(thickness: 2),
          _buildSummaryItem('Subtotal', formatNumber(subtotal)),
          _buildSummaryItem('Delivery Charge', formatNumber(deliveryCharge)),
          const Divider(thickness: 2),
          _buildSummaryItem(
            'Total',
            formatNumber(total),
            fontWeight: FontWeight.bold,
            textColor: const Color.fromRGBO(84, 181, 166, 1),
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in cartProvider.cart.items) {
      subtotal += item.product.price! * item.count;
    }
    return subtotal;
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    FontWeight fontWeight = FontWeight.normal,
    Color textColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$value \$',
            style: TextStyle(
              fontSize: 16,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
