import 'package:barbershop_mobile/screens/appointments_screen.dart';
import 'package:barbershop_mobile/screens/news_list_screen.dart';
import 'package:barbershop_mobile/screens/products_list_screen.dart';
import 'package:barbershop_mobile/screens/profile_screen.dart';
import 'package:barbershop_mobile/screens/reviews_list_screen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  static const routeName = '/home';

  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<Widget> _screens = [
    const NewsListScreen(),
    const AppointmentsScreen(),
    const ProductsListScreen(),
    const ReviewsListScreen(),
    const ProfileScreen()
  ];

  final List<IconData> _icons = const [
    Icons.home,
    Icons.calendar_today,
    Icons.shopping_cart,
    Icons.reviews,
    Icons.person
  ];

  final List<String> _labels = const [
    "News",
    "Appointments",
    "Shop",
    "Reviews",
    "Profile"
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Image.asset(
                'assets/images/appbar-logo.png',
                width: 50,
                height: 50,
              ),
            ),
            const Text(
              "Barbershop",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Color.fromRGBO(57, 131, 120, 1)),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: List.generate(_icons.length, (index) {
            return BottomNavigationBarItem(
                icon: Icon(
                  _icons[index],
                  size: 30,
                ),
                label: _labels[index]);
          }),
          selectedItemColor: Color.fromRGBO(213, 178, 99, 1),
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
