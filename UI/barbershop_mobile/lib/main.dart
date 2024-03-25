import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/account_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/news_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_brand_provider.dart';
import 'providers/product_provider.dart';
import 'providers/product_type_provider.dart';
import 'providers/review_provider.dart';
import 'providers/service_provider.dart';
import 'providers/user_provider.dart';
import 'screens/appointments_screen.dart';
import 'screens/news_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/review_add_screen.dart';
import 'screens/reviews_list_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/user_appointments_screen.dart';

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
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
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
          ReviewsListScreen.routeName: (context) => const ReviewsListScreen(),
          ReviewAddScreen.routeName: (context) => const ReviewAddScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        });
  }
}
