import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:barbershop_admin/providers/news_provider.dart';
import 'package:barbershop_admin/providers/product_provider.dart';
import 'package:barbershop_admin/screens/product_details_screen.dart';
import 'providers/account_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/user_provider.dart';
import 'providers/appointment_provider.dart';
import 'providers/product_brand_provider.dart';
import 'providers/product_type_provider.dart';
import 'providers/service_provider.dart';
import 'screens/login_screen.dart';
import 'screens/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(900, 600));
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ProductBrandProvider()),
      ChangeNotifierProvider(create: (_) => ProductTypeProvider()),
      ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Barbershop admin',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              color: Color.fromRGBO(57, 131, 120, 1),
              foregroundColor: Colors.white),
          fontFamily: GoogleFonts.roboto().fontFamily,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 50),
              backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(150, 50),
              foregroundColor: const Color.fromRGBO(57, 131, 120, 1),
              side: const BorderSide(
                color: Color.fromRGBO(57, 131, 120, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          Navigation.routeName: (context) => const Navigation(),
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen()
        });
  }
}
