// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_mobile/models/news.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailsScreen extends StatelessWidget {
  News? news;

  NewsDetailsScreen({
    Key? key,
    this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Center(
                  child: Text(
                    news?.title ?? '',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.tiltNeon(color: Colors.black, fontSize: 35),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (news?.photo != null) imageFromBase64String(news!.photo!),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  news?.content ?? '',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Published on: ${formatDate(news?.createdDateTime) ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
