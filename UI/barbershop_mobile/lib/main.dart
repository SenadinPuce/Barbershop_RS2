import 'package:barbershop_mobile/providers/fit_pasos_provider.dart';
import 'package:barbershop_mobile/providers/term_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:barbershop_mobile/providers/payment_provider.dart';
import 'package:barbershop_mobile/screens/cart_screen.dart';
import 'package:barbershop_mobile/screens/navigation.dart';
import 'package:barbershop_mobile/screens/news_details_screen.dart';
import 'package:barbershop_mobile/utils/constants.dart';

import 'providers/account_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/delivery_method_provider.dart';
import 'providers/news_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_brand_provider.dart';
import 'providers/product_provider.dart';
import 'providers/product_type_provider.dart';
import 'providers/review_provider.dart';
import 'providers/service_provider.dart';
import 'providers/user_provider.dart';
import 'screens/barbers_list_screen.dart';
import 'screens/news_list_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/user_appointments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishKey;

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
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => DeliveryMethodProvider()),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ChangeNotifierProvider(create: (_) => TermProvider()),
      ChangeNotifierProvider(create: (_) => FITPasosProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Barbershop mobile',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              color: Color.fromRGBO(57, 131, 120, 1),
              foregroundColor: Colors.white,
            ),
            fontFamily: GoogleFonts.roboto().fontFamily,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
            )),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                foregroundColor: Colors.white)),
        initialRoute: '/login',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          Navigation.routeName: (context) => const Navigation(),
          NewsListScreen.routeName: (context) => const NewsListScreen(),
          NewsDetailsScreen.routeName: (context) => const NewsDetailsScreen(),
          BarbersListScreen.routeName: (context) =>
              const BarbersListScreen(),
          UserAppointmentsScreen.routeName: (context) =>
              const UserAppointmentsScreen(),
          ProductsListScreen.routeName: (context) => const ProductsListScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        });
  }
}
