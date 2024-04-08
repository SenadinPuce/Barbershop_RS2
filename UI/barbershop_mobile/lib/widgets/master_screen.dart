import 'package:flutter/material.dart';

import '../screens/appointments_list_screen.dart';
import '../screens/news_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/reviews_list_screen.dart';
import '../screens/products_list_screen.dart';
import '../utils/util.dart';

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
  void _onItemTapped(int index) {
    ButtomNavigationBarHelper.currentIndex = index;

    if (ButtomNavigationBarHelper.currentIndex == 0) {
      Navigator.pushReplacementNamed(context, NewsListScreen.routeName);
    }
    if (ButtomNavigationBarHelper.currentIndex == 1) {
      Navigator.pushReplacementNamed(context, AppointmentsListScreen.routeName);
    }
    if (ButtomNavigationBarHelper.currentIndex == 2) {
      Navigator.pushReplacementNamed(context, ProductsListScreen.routeName);
    }
    if (ButtomNavigationBarHelper.currentIndex == 3) {
      Navigator.pushReplacementNamed(context, ReviewsListScreen.routeName);
    }
    if (ButtomNavigationBarHelper.currentIndex == 4) {
      Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: Colors.red,
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
          currentIndex: ButtomNavigationBarHelper.currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
