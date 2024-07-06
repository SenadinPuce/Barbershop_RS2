import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_app_bar.dart';
import 'reviews_list_screen.dart';
import 'terms_list_screen.dart';

class BarbersListScreen extends StatefulWidget {
  static const routeName = '/barbers';
  const BarbersListScreen({super.key});

  @override
  State<BarbersListScreen> createState() => _BarbersListScreen();
}

class _BarbersListScreen extends State<BarbersListScreen> {
  late UserProvider _userProvider;
  List<User>? _barbers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _userProvider = context.read<UserProvider>();

    var barbersData = await _userProvider.get(
      extraRoute: "get-barbers",
    );

    setState(() {
      _barbers = barbersData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildView(),
            const SizedBox(
              height: 80,
            )
          ],
        )),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
        child: Text(
          "Barbers",
          style: TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildView() {
    if (_isLoading) {
      return Container();
    } else {
      if (_barbers != null && _barbers!.isNotEmpty) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _barbers!.asMap().entries.map((entry) {
              final int index = entry.key;
              final User barber = entry.value;

              return _buildBarbersCard(index, barber);
            }).toList());
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Center(
            child: Text(
              'Something went wrong with loading barbers',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  Widget _buildBarbersCard(int index, User b) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 2.0,
          color: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: b.photo == null
                      ? Image.asset(
                          'assets/images/placeholder_profile.jpg',
                          height: 260,
                          width: 260,
                          gaplessPlayback: true,
                        )
                      : Image.memory(base64Decode(b.photo!),
                          height: 260, width: 260, gaplessPlayback: true),
                ),
                const SizedBox(height: 15),
                Text(
                  '${b.firstName} ${b.lastName}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54b5a6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      minimumSize: const Size(double.infinity, 45),
                      elevation: 3),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsListScreen(
                          barberId: b.id,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      minimumSize: const Size(double.infinity, 45),
                      elevation: 3),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsListScreen(
                          barberId: b.id!,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
