import 'package:barbershop_mobile/screens/appointments_list_screen.dart';
import 'package:barbershop_mobile/screens/news_list_screen.dart';
import 'package:barbershop_mobile/screens/products_list_screen.dart';
import 'package:barbershop_mobile/screens/profile_screen.dart';
import 'package:barbershop_mobile/screens/reviews_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Navigation extends StatefulWidget {
  static const routeName = '/home';

  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const NewsListScreen(),
      const AppointmentsListScreen(),
      const ProductsListScreen(),
      const ReviewsListScreen(),
      const ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    double iconSize = MediaQuery.of(context).size.height * 0.04;
    double labelFontSize = 14.0;

    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, size: iconSize),
        title: "Home",
        activeColorPrimary: const Color.fromRGBO(213, 178, 99, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today, size: iconSize),
        title: "Appointments",
        activeColorPrimary: const Color.fromRGBO(213, 178, 99, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart, size: iconSize),
        title: "Shop",
        activeColorPrimary: const Color.fromRGBO(213, 178, 99, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.reviews, size: iconSize),
        title: "Reviews",
        activeColorPrimary: const Color.fromRGBO(213, 178, 99, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person, size: iconSize),
        contentPadding: 0,
        title: "Profile",
        activeColorPrimary: const Color.fromRGBO(213, 178, 99, 1),
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenHeight * 0.09,
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
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: const Color.fromRGBO(57, 131, 120, 1),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style3,
        navBarHeight: screenHeight * 0.09,
      ),
    );
  }
}
