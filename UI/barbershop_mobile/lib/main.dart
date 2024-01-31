import 'package:barbershop_mobile/screens/appointments.dart';
import 'package:barbershop_mobile/screens/home.dart';
import 'package:barbershop_mobile/screens/profile.dart';
import 'package:barbershop_mobile/screens/reviews.dart';
import 'package:barbershop_mobile/screens/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/account_provider.dart';
import 'screens/navigation.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AccountProvider())],
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
          Login.routeName: (context) => const Login(),
          Register.routeName: (context) => const Register(),
          Navigation.routeName: (context) => const Navigation(),
          Home.routeName: (context) => const Home(),
          Appointments.routeName: (context) => const Appointments(),
          Shop.routeName: (context) => const Shop(),
          Reviews.routeName: (context) => const Reviews(),
          Profile.routeName: (context) => const Profile(),
        });
  }
}
