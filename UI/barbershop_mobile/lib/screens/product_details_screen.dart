// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_mobile/providers/cart_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product? product;
  ProductDetailsScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late CartProvider _cartProvider;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _cartProvider = context.read<CartProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to shop", style: GoogleFonts.tiltNeon(fontSize: 25)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.product?.name ?? "",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: imageFromBase64String(widget.product!.photo!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.product?.description ?? "",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Price: \$${formatNumber(widget.product?.price)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 111, 0, 1),
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _quantity.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    _cartProvider.addToCart(widget.product!, quantity: _quantity);
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                ),
              ],
            )),
      )),
    );
  }
}
