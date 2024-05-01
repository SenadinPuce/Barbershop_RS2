import 'package:barbershop_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbershop_mobile/screens/appointments_list_screen.dart';
import 'package:barbershop_mobile/screens/news_list_screen.dart';
import 'package:barbershop_mobile/screens/products_list_screen.dart';
import 'package:barbershop_mobile/screens/profile_screen.dart';
import 'package:barbershop_mobile/screens/reviews_list_screen.dart';

class Navigation extends StatefulWidget {
  static const routeName = '/home';

  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;

  final List<Widget> _screens = [
    const NewsListScreen(),
    const AppointmentsListScreen(),
    const ProductsListScreen(),
    const ReviewsListScreen(),
    const ProfileScreen(),
  ];

  final List<IconData> _icons = const [
    Icons.home,
    Icons.calendar_today,
    Icons.shopping_cart,
    Icons.reviews,
    Icons.person,
  ];

  final List<String> _labels = const [
    "News",
    "Appointments",
    "Shop",
    "Reviews",
    "Profile",
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _navigatorKeys =
        List.generate(_screens.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final navigator = _navigatorKeys[_currentIndex].currentState!;
        if (navigator.canPop()) {
          navigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: buildNavigator(),
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: const Color.fromRGBO(57, 131, 120, 1)),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: _currentIndex,
            onTap: (int index) {
              if (_currentIndex == index) {
                _navigatorKeys[_currentIndex]
                    .currentState!
                    .popUntil((route) => route.isFirst);
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            items: List.generate(_icons.length, (index) {
              return BottomNavigationBarItem(
                  icon: Icon(
                    _icons[index],
                    size: 40,
                  ),
                  label: _labels[index]);
            }),
            selectedItemColor: const Color.fromRGBO(213, 178, 99, 1),
            unselectedItemColor: Colors.white,
          ),
        ),
      ),
    );
  }

  buildNavigator() {
    return Navigator(
      key: _navigatorKeys[_currentIndex],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (_) => _screens.elementAt(_currentIndex));
      },
    );
  }
}
