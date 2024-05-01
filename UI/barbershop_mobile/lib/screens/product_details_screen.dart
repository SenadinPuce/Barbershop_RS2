// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_mobile/providers/cart_provider.dart';
import 'package:barbershop_mobile/providers/product_provider.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
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
  late ProductProvider _productProvider;
  List<Product>? _recommendedProducts;
  int _quantity = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cartProvider = context.read<CartProvider>();
    _productProvider = context.read<ProductProvider>();
    loadData();
  }

  loadData() async {
    var recommendedData = await _productProvider.recommend(widget.product!.id!);

    setState(() {
      _recommendedProducts = recommendedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Product details'),
      body: SafeArea(
          child: Stack(children: [
        SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: _buildProductView()),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ])),
    );
  }

  Widget _buildProductView() {
    if (isLoading) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.product?.name ?? "",
            style: const TextStyle(color: Colors.black, fontSize: 35),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 270,
                height: 270,
                child: imageFromBase64String(widget.product!.photo!),
              ),
            ),
          ),
          const SizedBox(height: 15),
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
                color: Color.fromRGBO(213, 178, 99, 1)),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 15),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          const SizedBox(height: 15),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            onPressed: () {
              _cartProvider.addToCart(widget.product!, quantity: _quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.green,
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    duration: Duration(seconds: 2),
                    content: Text('Product added to cart')),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              size: 25,
            ),
            label: const Text('Add to Cart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Others also bought:",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              height: 300,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 30),
                scrollDirection: Axis.horizontal,
                children: _buildProductsCardList(),
              )),
        ],
      );
    }
  }

  List<Widget> _buildProductsCardList() {
    List<Widget> list = _recommendedProducts!
        .map((p) => Card(
              elevation: 3,
              color: Colors.blueGrey[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                child: Column(children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: p,
                            ),
                          ),
                        );
                      },
                      child: imageFromBase64String(p.photo!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.name ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatNumber(p.price)} \$',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(213, 178, 99, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF54b5a6),
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () {
                      _cartProvider.addToCart(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                            duration: Duration(seconds: 2),
                            content: Text('Product added to cart')),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ]),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
