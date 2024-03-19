import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewAddScreen extends StatefulWidget {
  static const routeName = '/review-add';
  const ReviewAddScreen({super.key});

  @override
  State<ReviewAddScreen> createState() => _ReviewAddScreenState();
}

class _ReviewAddScreenState extends State<ReviewAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to reviews", style: GoogleFonts.tiltNeon(fontSize: 25)),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [Text("Review add screen will go here!")]),
        ),
      )),
    );
  }
}
