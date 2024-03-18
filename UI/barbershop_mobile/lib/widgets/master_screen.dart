import 'package:flutter/material.dart';

import '../screens/appointments_screen.dart';
import '../screens/news_list_screen.dart';
import '../screens/profile.dart';
import '../screens/reviews_list_screen.dart';
import '../screens/products_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;

  MasterScreenWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  static int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 0) {
      Navigator.pushNamed(context, NewsListScreen.routeName);
    }
    if (_currentIndex == 1) {
      Navigator.pushNamed(context, AppointmentsScreen.routeName);
    }
    if (_currentIndex == 2) {
      Navigator.pushNamed(context, ProductsListScreen.routeName);
    }
    if (_currentIndex == 3) {
      Navigator.pushNamed(context, Reviews.routeName);
    }
    if (_currentIndex == 4) {
      Navigator.pushNamed(context, Profile.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.blue,
        title: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: widget.child!),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue,
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Appointments'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Shop'),
            BottomNavigationBarItem(
                icon: Icon(Icons.reviews), label: 'Reviews'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
