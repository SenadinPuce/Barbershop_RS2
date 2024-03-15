import 'package:barbershop_mobile/models/type.dart';
import 'package:barbershop_mobile/providers/product_brand_provider.dart';
import 'package:barbershop_mobile/providers/product_provider.dart';
import 'package:barbershop_mobile/providers/product_type_provider.dart';
import 'package:barbershop_mobile/providers/service_provider.dart';
import 'package:barbershop_mobile/screens/user_appointments_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/account_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/news_provider.dart';
import 'screens/appointments_screen.dart';
import 'screens/news_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile.dart';
import 'screens/register_screen.dart';
import 'screens/reviews.dart';
import 'screens/products_list_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductTypeProvider()),
      ChangeNotifierProvider(create: (_) => ProductBrandProvider()),
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
          AppointmentsScreen.routeName: (context) => const AppointmentsScreen(),
          UserAppointmentsScreen.routeName: (context) =>
              const UserAppointmentsScreen(),
          ProductsListScreen.routeName: (context) => const ProductsListScreen(),
          Reviews.routeName: (context) => const Reviews(),
          Profile.routeName: (context) => const Profile(),
        });
  }
}
