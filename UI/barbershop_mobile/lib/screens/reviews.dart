import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  static const routeName = '/Reviews';
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text("Reviews will go here"),
      )),
    );
  }
}
