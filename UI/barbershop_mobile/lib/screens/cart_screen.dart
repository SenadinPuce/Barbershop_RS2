import 'package:barbershop_mobile/screens/checkout_screen.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:barbershop_mobile/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';
import '../utils/util.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();

    if (_cartProvider.cart.items.isEmpty) {
      _cartProvider.selectedDeliveryMethod = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Your cart'),
        body: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProductCardList(),
                const SizedBox(
                  height: 10,
                ),
                if (_cartProvider.cart.items.isNotEmpty)
                  OrderSummaryWidget(
                    cartProvider: _cartProvider,
                  ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          if (_cartProvider.cart.items.isEmpty)
            const Center(
              child: Text(
                'Your Cart is currently empty.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          else
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildProceedButton(),
            ),
        ]));
  }

  Widget _buildProductCardList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cartProvider.cart.items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_cartProvider.cart.items[index]);
      },
    );
  }

  Widget _buildProductCard(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 2,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: imageFromBase64String(item.product.photo!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: ${item.product.price} \$',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Quantity: ${item.count}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(
                      color: Color.fromRGBO(213, 178, 99, 1),
                      thickness: 2.0,
                    ),
                    Text(
                      'Total: ${formatNumber(item.product.price! * item.count)} \$',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Color(0xfff71133),
                  size: 30,
                ),
                onPressed: () {
                  _cartProvider.removeFromCart(item.product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(double.infinity, 45),
              elevation: 3),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckoutScreen(),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
