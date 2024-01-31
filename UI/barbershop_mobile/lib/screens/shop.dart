import 'package:flutter/material.dart';

class Shop extends StatefulWidget {
  static const routeName = '/shop';
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text("Shop will go here"),
      )),
    );
  }
}
