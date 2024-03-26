import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';
import '../utils/util.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartProvider = context.watch<CartProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to shop", style: GoogleFonts.tiltNeon(fontSize: 25)),
      ),
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProductCardList(),
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
      ])),
    );
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
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: imageFromBase64String(item.product.photo!),
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
                      color: Colors.amber,
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
                  Icons.remove_shopping_cart,
                  color: Colors.red,
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
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(double.infinity, 45),
              elevation: 3),
          onPressed: () async {},
          child: const Text(
            'Proceed to Checkout',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
