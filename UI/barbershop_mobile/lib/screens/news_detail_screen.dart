// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';

import '../models/news.dart';

class NewsDetailScreen extends StatefulWidget {
  News? news;

  NewsDetailScreen({
    Key? key,
    this.news,
  }) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Text(widget.news!.title!),
    );
  }
}
