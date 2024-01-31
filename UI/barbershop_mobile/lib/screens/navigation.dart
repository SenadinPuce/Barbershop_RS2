import 'package:barbershop_mobile/screens/profile.dart';
import 'package:barbershop_mobile/screens/reviews.dart';
import 'package:barbershop_mobile/screens/shop.dart';
import 'package:flutter/material.dart';

import 'appointments.dart';
import 'home.dart';

class Navigation extends StatefulWidget {
  static const routeName = '/Navigation';

  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<Widget> _screens = [
    const Home(),
    const Appointments(),
    const Shop(),
    const Reviews(),
    const Profile()
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.calendar_today,
    Icons.shopping_cart,
    Icons.reviews,
    Icons.person
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _icons.map((IconData icon) {
          return BottomNavigationBarItem(
              icon: Icon(
                icon,
                size: 35,
              ),
              label: '');
        }).toList(),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
      ),
    );
  }
}
