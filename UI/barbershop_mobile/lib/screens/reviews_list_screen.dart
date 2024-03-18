import 'package:barbershop_mobile/widgets/master_screen.dart';
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
    return MasterScreenWidget(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      )),
    );
  }
}
