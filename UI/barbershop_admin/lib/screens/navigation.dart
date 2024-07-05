// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop_admin/screens/login_screen.dart';
import 'package:barbershop_admin/screens/news_list_screen.dart';
import 'package:barbershop_admin/screens/products_list_screen.dart';
import 'package:barbershop_admin/screens/profile_screen.dart';
import 'package:barbershop_admin/screens/terms_list_screen.dart';
import 'package:barbershop_admin/screens/users_list_screen.dart';
import 'package:flutter/material.dart';

import '../utils/util.dart';
import 'appointments_list_screen.dart';
import 'orders_list_screen.dart';
import 'reports_screen.dart';
import 'services_list_screen.dart';

class NavigationItem {
  final Icon icon;
  final String label;
  final Widget widget;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.widget,
  });
}

class Navigation extends StatefulWidget {
  static const routeName = "/navigation";
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    if (Authorization.roles!.contains("Admin"))
      NavigationItem(
        icon: const Icon(Icons.group),
        label: "Users",
        widget: const UsersListScreen(),
      ),
    NavigationItem(
      icon: const Icon(Icons.calendar_today),
      label: "Terms",
      widget: const TermsListScreen(),
    ),
    NavigationItem(
      icon: const Icon(Icons.event),
      label: "Appointments",
      widget: const AppointmentsListScreen(),
    ),
    NavigationItem(
      icon: const Icon(Icons.category),
      label: "Products",
      widget: const ProductsListScreen(),
    ),
    NavigationItem(
      icon: const Icon(Icons.cut),
      label: "Services",
      widget: const ServicesListScreen(),
    ),
    NavigationItem(
      icon: const Icon(Icons.newspaper),
      label: "News",
      widget: const NewsListScreen(),
    ),
    NavigationItem(
      icon: const Icon(Icons.list),
      label: "Orders",
      widget: const OrdersListScreen(),
    ),
    if (Authorization.roles!.contains("Admin"))
      NavigationItem(
        icon: const Icon(Icons.bar_chart),
        label: "Reports",
        widget: const ReportsScreen(),
      ),
    NavigationItem(
      icon: const Icon(Icons.person),
      label: "Profile",
      widget: const ProfileScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_navigationItems[_selectedIndex].label),
            Image.asset(
              'assets/images/appbar-logo.png',
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
      body: Center(child: _navigationItems[_selectedIndex].widget),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(57, 131, 120, 1),
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 32,
                    child: Image.asset(
                      'assets/images/appbar-logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome ${toTitleCase(Authorization.username.toString())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _navigationItems.length,
                itemBuilder: (BuildContext context, index) {
                  final item = _navigationItems[index];
                  final isSelected = _selectedIndex == index;

                  return ListTile(
                    leading: Icon(
                      item.icon.icon,
                      color: isSelected
                          ? const Color.fromRGBO(213, 178, 99, 1)
                          : Colors.white,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? const Color.fromRGBO(213, 178, 99, 1)
                            : Colors.white,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      _onItemTapped(index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
