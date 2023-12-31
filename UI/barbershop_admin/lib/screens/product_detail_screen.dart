// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/master_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  Product? product;
  ProductDetailScreen({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: 'Product details',
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [Text(widget.product!.name.toString())],
            )));
  }
}
