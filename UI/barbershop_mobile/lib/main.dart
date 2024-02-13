import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/account_provider.dart';
import 'providers/news_provider.dart';
import 'screens/appointments.dart';
import 'screens/news_list_screen.dart';
import 'widgets/master_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile.dart';
import 'screens/register_screen.dart';
import 'screens/reviews.dart';
import 'screens/shop.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Barbershop mobile',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          NewsListScreen.routeName: (context) => const NewsListScreen(),
          Appointments.routeName: (context) => const Appointments(),
          Shop.routeName: (context) => const Shop(),
          Reviews.routeName: (context) => const Reviews(),
          Profile.routeName: (context) => const Profile(),
        });
  }
}
